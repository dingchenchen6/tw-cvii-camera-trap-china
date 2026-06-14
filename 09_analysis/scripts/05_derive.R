#!/usr/bin/env Rscript
# =============================================================================
# 05_derive.R — 派生 survey_adequacy_detection + evidence_state + 生成 v2_analysis_ready
#   规则: cleaning_rules.md §7(充分性阈值) + schema.md §2.4(四类证据状态)
# 用法: Rscript 09_analysis/scripts/05_derive.R
# =============================================================================
source("09_analysis/scripts/01_helpers.R")

message("=== 阶段E: 派生指标 + 证据状态 → v2_analysis_ready ===")
if (file.exists(DB_V2)) file.remove(DB_V2)
file.copy(DB_V1, DB_V2)
con <- dbConnect(duckdb(), dbdir = DB_V2, read_only = FALSE)
on.exit(dbDisconnect(con), add = TRUE)

# ---- 1) survey_adequacy_detection ----
# 按类群阈值 (cleaning_rules.md §7 / workflow §15.1) 判定每个 site-类群 的充分性
# 站点努力量来自 study 汇总
eff <- dbGetQuery(con,
  "SELECT si.site_id, si.study_id,
          st.total_camera_days_reported AS camera_days,
          st.total_station_count_reported AS station_count,
          st.study_start_date, st.study_end_date,
          DATE_diff('day', st.study_start_date, st.study_end_date) AS duration_days
   FROM study st JOIN site si ON st.study_id = si.study_id")

# 类群→阈值映射 (camera_days_min, station_min, season 要求)
group_threshold <- tibble::tribble(
  ~taxonomic_scope, ~cd_min, ~stn_min, ~label,
  "mammals",        1000,    15,      "mesocarnivore baseline (>=1000 cd, >=15 stations)",
  "large carnivores",5000,   30,      "large carnivore baseline (>=5000 cd, >=30 stations)",
  "ungulates+ground birds", 700, 11,  "ungulate/ground-bird baseline (>=600-800 cd, >=10-12 stations)"
)

adeq_rows <- list()
for (i in seq_len(nrow(eff))) {
  e <- eff[i, ]
  cd <- e$camera_days; stn <- e$station_count
  dur <- e$duration_days
  full_year <- !is.na(dur) && dur >= 330
  for (j in seq_len(nrow(group_threshold))) {
    g <- group_threshold[j, ]
    adequate <- (!is.na(cd) && cd >= g$cd_min && !is.na(stn) && stn >= g$stn_min)
    adeq_rows[[length(adeq_rows)+1]] <- tibble::tibble(
      site_id = e$site_id, species_id = NA_character_,
      taxonomic_scope = g$taxonomic_scope,
      camera_days = cd, station_count = stn,
      survey_duration_days = dur, survey_area_km2 = NA_real_,
      season_coverage = if (full_year) "full_year" else "multiple",
      habitat_coverage_score = NA_integer_,
      effort_threshold_rule = g$label,
      adequate_for_inventory = "yes",
      adequate_for_species_group = if (adequate) "yes" else "no",
      detection_probability_estimate = NA_real_,
      detection_model_type = "none",
      detection_covariates_used = NA_character_,
      adequacy_confidence = "medium",
      notes = NA_character_)
  }
}
adeq <- do.call(rbind, adeq_rows) %>%
  mutate(adequacy_id = next_id(con, "ADQ", "survey_adequacy_detection", "adequacy_id", n()))
dbAppendTable(con, "survey_adequacy_detection", as.data.frame(adeq))

# ---- 2) evidence_state ----
# 站点级充分性: 任一类群 adequate_for_species_group=yes 即视为该 site adequate
# (种子阶段用 mammals 基线: 7964 cd >= 1000 且 32 stations >= 15 → adequate)
site_adequate <- adeq %>%
  group_by(site_id) %>%
  summarise(any_adequate = any(adequate_for_species_group == "yes"), .groups = "drop")

# 对每个被探测到的物种生成 evidence_state:
#   contemporary_detected=yes → confirmed_persistence
#   (silent_range 需 historical_expectation，种子阶段无历史预期 → 暂只标 detected)
# 每个 species×site 取一条(汇总多条 measurement)
det <- dbGetQuery(con,
  "SELECT species_id, site_id,
          MAX(measurement_value_standard) AS recs
   FROM species_site_measurement
   WHERE diversity_metric_type = 'independent_records'
   GROUP BY species_id, site_id")

rai <- dbGetQuery(con,
  "SELECT species_id, site_id,
          MAX(measurement_value_standard) AS rai
   FROM species_site_measurement
   WHERE diversity_metric_type = 'RAI'
   GROUP BY species_id, site_id")
ev_rows <- det %>%
  left_join(site_adequate, by = "site_id") %>%
  left_join(rai, by = c("species_id","site_id")) %>%
  mutate(
    evidence_id              = next_id(con, "EVD", "evidence_state", "evidence_id", n()),
    spatial_unit_id          = site_id,
    baseline_scenario        = "intermediate",
    historically_expected    = "uncertain",
    contemporary_detected    = "yes",
    contemporary_evidence_type = "camera_trap",
    latest_detection_year    = 2023L,
    first_detection_year     = NA_integer_,
    rai_per_100_camera_days  = rai,
    occupancy_or_detection_corrected_value = NA_real_,
    survey_adequacy_status   = ifelse(any_adequate, "adequate", "inadequate"),
    evidence_state           = "confirmed_persistence",
    evidence_confidence      = ifelse(any_adequate, "high", "medium"),
    state_reason             = "contemporary camera-trap detection in current study",
    state_version            = "v1.0-seed"
  ) %>%
  select(evidence_id, species_id, site_id, spatial_unit_id,
         baseline_scenario, historically_expected, contemporary_detected,
         contemporary_evidence_type, latest_detection_year, first_detection_year,
         independent_records = recs, rai_per_100_camera_days,
         occupancy_or_detection_corrected_value, survey_adequacy_status,
         evidence_state, evidence_confidence, state_reason, state_version)
dbAppendTable(con, "evidence_state", as.data.frame(ev_rows))

# ---- 3) derived_index (站点级 TW-CVII 占位) ----
# 种子阶段: 只有 confirmed_persistence，无 historical_expectation →
# species_intactness 暂无法算(分母缺)；先填可计算的分量并置 NA
idx <- ev_rows %>%
  group_by(site_id = spatial_unit_id) %>%
  summarise(confirmed_species_n = n(),
            adequately_surveyed_species_n = n(), .groups = "drop") %>%
  mutate(
    index_id = next_id(con, "IDX", "derived_index", "index_id", n()),
    spatial_unit_id = site_id, spatial_unit_type = "site",
    taxonomic_scope = "mammals", baseline_scenario = "intermediate",
    species_intactness = NA_real_,        # 待 historical_expectation
    detection_corrected_intactness = NA_real_,
    threat_weighted_intactness = NA_real_,
    functional_intactness = NA_real_,
    abundance_proxy_intactness = NA_real_,
    silent_range_proportion = 0,
    monitoring_gap_proportion = 0,
    newly_confirmed_proportion = NA_real_,
    expected_species_n = NA_integer_,
    index_rule_version = "v1.0-seed",
    database_version = "v2_analysis_ready"
  )
dbAppendTable(con, "derived_index", as.data.frame(idx %>% select(-site_id)))

# ---- 4) 汇总 ----
message("\n✓ v2_analysis_ready 派生完成:")
cnt <- dbGetQuery(con,
  "SELECT 'survey_adequacy_detection' t, COUNT(*) n FROM survey_adequacy_detection UNION ALL
   SELECT 'evidence_state', COUNT(*) FROM evidence_state UNION ALL
   SELECT 'derived_index', COUNT(*) FROM derived_index UNION ALL
   SELECT 'confirmed_persistence 物种', COUNT(*) FROM evidence_state WHERE evidence_state='confirmed_persistence'")
print(cnt, row.names=FALSE, right=FALSE)
message("  注: TW-CVII 主指数(species_intactness 等)需 historical_expectation 数据，")
message("      种子阶段置 NA；待补历史预期来源(方志/博物馆/历史调查)后由 05_derive.R 重算。")
message("  数据库: ", DB_V2)
