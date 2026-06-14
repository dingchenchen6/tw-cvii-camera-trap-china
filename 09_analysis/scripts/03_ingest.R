#!/usr/bin/env Rscript
# =============================================================================
# 03_ingest.R — 读 verified CSV → 清洗 → 写入 v1_cleaned_core.duckdb
#   覆盖: source, study, site, species_site_measurement, extraction_audit
#   清洗: 分类学名匹配参考表、RAI 标准化(÷camera_days×100)、日期 ISO、缺失码
# 用法: Rscript 09_analysis/scripts/03_ingest.R
# =============================================================================
source("09_analysis/scripts/01_helpers.R")

VER <- VER_CSV_DIR  # 06_extraction_verified/

# 1) 复制 v0(含参考表) 为 v1 基底
message("=== 阶段D: 清洗 + 入库 → v1_cleaned_core ===")
if (file.exists(DB_V1)) file.remove(DB_V1)
file.copy(DB_V0, DB_V1)
con <- dbConnect(duckdb(), dbdir = DB_V1, read_only = FALSE)
on.exit(dbDisconnect(con), add = TRUE)

# 2) 读 verified CSV
v_src  <- read_csv(file.path(VER, "seed_sources.csv"),            show_col_types = FALSE)
v_stu  <- read_csv(file.path(VER, "seed_studies.csv"),            show_col_types = FALSE)
v_site <- read_csv(file.path(VER, "seed_sites.csv"),              show_col_types = FALSE)
v_inv  <- read_csv(file.path(VER, "seed_species_inventory.csv"),  show_col_types = FALSE)
v_aud  <- read_csv(file.path(VER, "seed_extraction_audit.csv"),   show_col_types = FALSE)

# ---- 3) 清洗并写入各表 ----
# source
src <- v_src
dbAppendTable(con, "source", as.data.frame(src))

# study: 日期 ISO 化
stu <- v_stu %>%
  mutate(study_start_date = to_date(study_start_date),
         study_end_date   = to_date(study_end_date))
dbAppendTable(con, "study", as.data.frame(stu))

# site: 坐标/精度保持；survey_area 用 NA 表示（文献未报告调查面积）
site <- v_site %>%
  mutate(latitude = to_num(latitude), longitude = to_num(longitude),
         elevation_min_m = to_num(elevation_min_m),
         elevation_max_m = to_num(elevation_max_m),
         protected_area_total_km2 = to_num(protected_area_total_km2),
         study_id = stu$study_id[1])
dbAppendTable(con, "site", as.data.frame(site))

# 4) 物种清单 → 匹配参考表 taxonomy → 写 species_site_measurement
ref_tax <- dbGetQuery(con,
  'SELECT species_id, scientific_name_accepted, chinese_name_standard,
          "class", "order", family FROM taxonomy')

# 对每个抽取物种，先尝试在参考表中匹配；未命中则新增 taxonomy 记录
inv_clean <- v_inv %>%
  mutate(key = tolower(trimws(scientific_name_accepted)))

ref_key <- ref_tax %>%
  mutate(key = tolower(trimws(scientific_name_accepted)))

matched <- inv_clean %>%
  left_join(ref_key, by = "key", suffix = c("", "_ref"))

# 新增未命中的物种到 taxonomy(最小记录，conservation/functional 留空待补)
new_species <- matched %>% filter(is.na(species_id))
if (nrow(new_species) > 0) {
  message(sprintf("  新增 %d 个未在参考表中的物种", nrow(new_species)))
  for (i in seq_len(nrow(new_species))) {
    r <- new_species[i, ]
    sid <- next_id(con, "SP", "taxonomy", "species_id", 1)
    dbExecute(con, sprintf(
      "INSERT INTO taxonomy(species_id, scientific_name_accepted, chinese_name_standard,
         scientific_name_original, name_status, taxon_rank, kingdom, phylum,
         class, \"order\", family, taxonomy_source)
       VALUES ('%s','%s','%s','%s','accepted','species','Animalia','Chordata','%s','%s','%s','manual')",
      sid, r$scientific_name_accepted, r$chinese_name,
      r$scientific_name_original,
      r$class, r$order, r$family))
    matched$species_id[matched$key == r$key & is.na(matched$species_id)] <- sid
  }
}

# 5) species_site_measurement (RAI 已标准化为 per_100_camera_days)
# 用 inventory CSV 里每行的 source_id/study_id/site_id（支持多篇文献）
eff_by_study <- stu %>% select(study_id, total_camera_days_reported) %>%
  rename(camera_days = total_camera_days_reported)
meas <- matched %>%
  transmute(
    source_id              = source_id,
    study_id               = study_id,
    site_id                = site_id,
    species_id             = species_id,
    taxon_name_entered     = species_original,
    measurement            = "independent_records",
    diversity_metric_type  = "independent_records",
    diversity_metric       = "Number of independent photos",
    diversity_metric_unit  = "count",
    metric_is_effort_sensitive = "yes",
    camera_days_join       = study_id,
    measurement_value_standard = to_num(independent_records),
    measurement_unit_standard = "count",
    denominator            = "camera_days",
    formula_reported       = "independent detections per 100 camera days",
    zero_record_interpretation = "true_zero",
    extraction_page        = extraction_page,
    verification_status    = "verified"
  ) %>%
  left_join(eff_by_study, by = c("camera_days_join"="study_id")) %>%
  rename(sampling_effort = camera_days) %>% select(-camera_days_join) %>%
  mutate(sampling_effort_unit = "camera_days",
         measurement_id = next_id(con, "MET", "species_site_measurement", "measurement_id", n()))
dbAppendTable(con, "species_site_measurement", as.data.frame(meas))

# RAI 也作为单独 measurement 记录(已标准化)
meas_rai <- matched %>%
  transmute(
    source_id = source_id, study_id = study_id, site_id = site_id,
    species_id = species_id, taxon_name_entered = species_original,
    measurement = "RAI", diversity_metric_type = "RAI",
    diversity_metric = "Relative Abundance Index",
    diversity_metric_unit = "per_100_camera_days", metric_is_effort_sensitive = "yes",
    camera_days_join = study_id,
    measurement_value_standard = to_num(rai_per_100_camera_days),
    measurement_unit_standard = "per_100_camera_days", denominator = "camera_days",
    formula_reported = "independent detections / 100 camera-days",
    zero_record_interpretation = "true_zero",
    extraction_page = extraction_page, verification_status = "verified"
  ) %>%
  left_join(eff_by_study, by = c("camera_days_join"="study_id")) %>%
  rename(sampling_effort = camera_days) %>% select(-camera_days_join) %>%
  mutate(sampling_effort_unit = "camera_days",
         measurement_id = next_id(con, "MET", "species_site_measurement", "measurement_id", n()))
dbAppendTable(con, "species_site_measurement", as.data.frame(meas_rai))

# 6) extraction_audit
aud <- v_aud %>% mutate(extraction_date = to_date(extraction_date),
                        verification_date = to_date(verification_date)) %>%
  mutate(audit_id = next_id(con, "AUD", "extraction_audit", "audit_id", n()))
dbAppendTable(con, "extraction_audit", as.data.frame(aud))

# 7) 汇总
counts <- dbGetQuery(con,
  "SELECT 'source' t, COUNT(*) n FROM source UNION ALL
   SELECT 'study', COUNT(*) FROM study UNION ALL
   SELECT 'site', COUNT(*) FROM site UNION ALL
   SELECT 'species_site_measurement', COUNT(*) FROM species_site_measurement UNION ALL
   SELECT 'taxonomy', COUNT(*) FROM taxonomy UNION ALL
   SELECT 'extraction_audit', COUNT(*) FROM extraction_audit")
message("\n✓ v1_cleaned_core 入库完成:")
print(counts, row.names = FALSE, right = FALSE)
message("  ", nrow(v_inv), " 个物种记录 × 2 指标(independent_records + RAI) = ",
        nrow(v_inv)*2, " 条 measurement")
message("  数据库: ", DB_V1)
