#!/usr/bin/env Rscript
# =============================================================================
# 07_release_manifest.R — 生成 database_release_manifest.csv (记录数 + 校验和)
# 用法: Rscript 09_analysis/scripts/07_release_manifest.R
# =============================================================================
source("09_analysis/scripts/01_helpers.R")
suppressPackageStartupMessages(library(dplyr))

versions <- list(
  list(ver="v0_raw_ingest",     db=DB_V0),
  list(ver="v1_cleaned_core",   db=DB_V1),
  list(ver="v2_analysis_ready", db=DB_V2))

out <- file.path(DB_DIR, "database_release_manifest.csv")
rows <- list()
for (v in versions) {
  if (!file.exists(v$db)) next
  con <- dbConnect(duckdb(), dbdir=v$db, read_only=TRUE)
  tabs <- dbGetQuery(con, "SELECT table_name FROM information_schema.tables
                          WHERE table_schema='main' AND table_type='BASE TABLE'")
  cnts <- sapply(tabs$table_name, function(t)
    tryCatch(dbGetQuery(con, paste0("SELECT COUNT(*) n FROM \"",t,"\""))$n[1], error=function(e) 0L))
  dbDisconnect(con)
  rows[[length(rows)+1]] <- data.frame(
    release_version        = v$ver,
    release_file           = basename(v$db),
    schema_version         = "schema.sql v1 (2026-06-13)",
    release_date           = Sys.Date(),
    record_counts_by_table = paste(paste0(names(cnts),":",cnts), collapse="; "),
    checksum_sha256        = file_sha256(v$db),
    qa_report_path         = if (v$ver=="v2_analysis_ready") "12_audits/qa_gate_reports/" else "",
    known_limitations      = if (v$ver=="v2_analysis_ready")
      "seed=1 paper (Zhao2026 Huangshan); historical_expectation empty; some species lack conservation_status; site coords=centroid" else "",
    released_by            = "TW-CVII pipeline",
    stringsAsFactors       = FALSE)
}
manifest <- do.call(rbind, rows)
write.csv(manifest, out, row.names=FALSE)
message("✓ release manifest → ", out)
print(manifest[, c("release_version","release_file","release_date")], row.names=FALSE)
