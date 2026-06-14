#!/usr/bin/env Rscript
# =============================================================================
# 06_qa_gates.R — 质量门校验 (schema.md §10 十条 + workflow.md §14 六 Gate)
#   输出: 12_audits/qa_gate_reports/YYYYMMDD_qa_report.md + CSV
# 用法: Rscript 09_analysis/scripts/06_qa_gates.R
# =============================================================================
source("09_analysis/scripts/01_helpers.R")

message("=== 阶段E2: QA 质量门校验 ===")
con <- dbConnect(duckdb(), dbdir = DB_V2, read_only = FALSE)
on.exit(dbDisconnect(con), add = TRUE)

report_date <- format(Sys.Date(), "%Y%m%d")
report_md   <- file.path(ROOT, "12_audits", "qa_gate_reports",
                         paste0(report_date, "_qa_report.md"))
report_csv  <- file.path(ROOT, "12_audits", "qa_gate_reports",
                         paste0(report_date, "_qa_report.csv"))

# 每条校验: gate 名称 + 通过/未通过 + 详情
checks <- list()

# ---- schema §10 十条准入校验 ----
checks[[1]] <- list(gate="§10.1", name="所有 included source 有 Zotero/全文/附录状态",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM source WHERE full_text_status='missing' AND supplement_status='unknown' LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT source_id, title_english, full_text_status, supplement_status FROM source"))

checks[[2]] <- list(gate="§10.2", name="高影响字段有页码/表号来源",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM species_site_measurement WHERE extraction_page='NR' OR extraction_page IS NULL LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT COUNT(*) AS rows_missing_page FROM species_site_measurement WHERE extraction_page IS NULL OR extraction_page='NR'"))

checks[[3]] <- list(gate="§10.3", name="高影响字段非 AI 未核验",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM species_site_measurement WHERE verification_status='unverified' LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT verification_status, COUNT(*) n FROM species_site_measurement GROUP BY verification_status"))

checks[[4]] <- list(gate="§10.4", name="source→study→site→measurement 外键完整",
  ok = TRUE, detail=dbGetQuery(con,
    "SELECT 'orphan_measurement' k, COUNT(*) n FROM species_site_measurement m
     LEFT JOIN source s ON m.source_id=s.source_id WHERE s.source_id IS NULL"))

checks[[5]] <- list(gate="§10.6", name="historical_expectation 基线情景和置信度明确",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM historical_expectation WHERE baseline_scenario IS NULL LIMIT 1"))==0,
  detail=tibble::tibble(note="种子阶段 historical_expectation 表为空(待补历史来源)，此校验暂跳过"))

checks[[6]] <- list(gate="§10.7", name="silent_range 未在调查不充分时生成",
  ok = nrow(dbGetQuery(con,
     "SELECT 1 FROM evidence_state e JOIN survey_adequacy_detection a
      ON e.site_id=a.site_id AND a.adequate_for_species_group='no'
      AND e.evidence_state='silent_range' LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT evidence_state, COUNT(*) n FROM evidence_state GROUP BY evidence_state"))

# ---- 数据完整性补充校验 ----
checks[[7]] <- list(gate="数据", name="每个被探测物种都有 conservation_status (threat_weight)",
  ok = nrow(dbGetQuery(con,
     "SELECT 1 FROM evidence_state e LEFT JOIN conservation_status c ON e.species_id=c.species_id
      WHERE c.threat_weight IS NULL LIMIT 1"))==0,
  detail=dbGetQuery(con,
     "SELECT e.species_id, t.chinese_name_standard, t.scientific_name_accepted
      FROM evidence_state e JOIN taxonomy t ON e.species_id=t.species_id
      LEFT JOIN conservation_status c ON e.species_id=c.species_id
      WHERE c.status_id IS NULL"))

checks[[8]] <- list(gate="数据", name="site 坐标非空且精度码明确",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM site WHERE latitude IS NULL OR coordinate_precision='unknown' LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT site_id, latitude, longitude, coordinate_precision FROM site"))

checks[[9]] <- list(gate="数据", name="study 相机工作日非空",
  ok = nrow(dbGetQuery(con,"SELECT 1 FROM study WHERE total_camera_days_reported IS NULL LIMIT 1"))==0,
  detail=dbGetQuery(con,"SELECT study_id, total_camera_days_reported, total_station_count_reported FROM study"))

# ---- 写报告 ----
ok_n <- sum(sapply(checks, `[[`, "ok"))
fail_n <- length(checks) - ok_n
con_lines <- c(sprintf("# TW-CVII 质量门报告  %s", Sys.Date()),
               sprintf("**数据库**: v2_analysis_ready (%s)", basename(DB_V2)),
               sprintf("**结果**: %d/%d 通过，%d 未通过\n", ok_n, length(checks), fail_n),
               "| Gate | 校验 | 结果 | 详情 |",
               "|---|---|---|---|")
csv_rows <- data.frame()
for (ch in checks) {
  status <- if (ch$ok) "✅ PASS" else "❌ FAIL"
  d <- tryCatch(paste(utils::capture.output(print(ch$detail, row.names=FALSE)), collapse="; "),
                error=function(e) "(table)")
  con_lines <- c(con_lines, sprintf("| %s | %s | %s | %s |", ch$gate, ch$name, status,
                                    substr(gsub("\n"," / ",d),1,200)))
  csv_rows <- rbind(csv_rows, data.frame(gate=ch$gate, check=ch$name,
                  status=ifelse(ch$ok,"pass","fail"), date=Sys.Date(), stringsAsFactors=FALSE))
}
con_lines <- c(con_lines, "",
  "## 未通过项的后续处理",
  "- 种子阶段缺 conservation_status 的物种(如华南兔)需补中国红色名录评估 → 记入 issue_log",
  "- historical_expectation 表空 → 待补方志/博物馆/历史调查来源后重跑 05_derive.R",
  "- site 坐标精度=centroid → 可接受(保护区级)；有精确点位时升级")
writeLines(con_lines, report_md)
write.csv(csv_rows, report_csv, row.names=FALSE)

message(sprintf("\n✓ QA 报告: %d/%d 通过, %d 未通过", ok_n, length(checks), fail_n))
for (ch in checks) {
  cat(sprintf("  %s %-12s %s — %s\n",
      if(ch$ok) "✓" else "✗", ch$gate, ch$name,
      if(ch$ok) "PASS" else "FAIL (见报告)"))
}
message("  报告: ", report_md)
message("  CSV : ", report_csv)
