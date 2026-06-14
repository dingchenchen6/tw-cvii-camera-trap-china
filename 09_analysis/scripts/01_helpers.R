#!/usr/bin/env Rscript
# =============================================================================
# 01_helpers.R — 共享工具：ID 分配器 + 路径常量 + 缺失码
# 被 02_*.R ~ 06_*.R 通过 source() 加载。
# =============================================================================
suppressPackageStartupMessages({
  library(DBI); library(duckdb); library(dplyr); library(readr); library(stringi)
})

# ---- 路径常量（脚本自定位）----
SCRIPT_DIR <- tryCatch({
  args <- commandArgs(trailingOnly = FALSE)
  arg <- sub("^--file=", "", args[grep("^--file=", args)])
  if (length(arg) && nzchar(arg)) normalizePath(dirname(arg)) else "."
}, error = function(e) ".")
if (!nzchar(SCRIPT_DIR) || SCRIPT_DIR == ".") SCRIPT_DIR <- "09_analysis/scripts"
ROOT        <- normalizePath(file.path(SCRIPT_DIR, "..", ".."))
DB_DIR      <- file.path(ROOT, "08_database")
RAW_CSV_DIR <- file.path(ROOT, "05_extraction_raw", "ai_candidate_tables")
VER_CSV_DIR <- file.path(ROOT, "06_extraction_verified")
SCHEMA_SQL  <- file.path(DB_DIR, "01_schema.sql")

DB_V0 <- file.path(DB_DIR, "camera_trap_v0_raw_ingest.duckdb")
DB_V1 <- file.path(DB_DIR, "camera_trap_v1_cleaned_core.duckdb")
DB_V2 <- file.path(DB_DIR, "camera_trap_v2_analysis_ready.duckdb")
DB_V3 <- file.path(DB_DIR, "camera_trap_v3_manuscript_freeze.duckdb")

# ---- 缺失码 ----
MISSING <- c("NR","NA","UNK","PENDING","EXTRACTED_UNVERIFIED","RESTRICTED")
is_missing <- function(x) is.na(x) | x %in% MISSING | !nzchar(x)

# ---- ID 分配器：从表当前最大序号递增 ----
# prefix_table: c(source="SRC", study="STU", block="BLK", site="SITE",
#                 deployment="DEP", species="SP", measurement="MET", ...)
next_id <- function(con, prefix, table, id_col, n = 1) {
  q <- sprintf("SELECT %s FROM %s WHERE %s LIKE '%s%%'", id_col, table, id_col, prefix)
  existing <- tryCatch(dbGetQuery(con, q)[[id_col]], error = function(e) character(0))
  nums <- as.integer(gsub("\\D", "", existing))
  start <- if (length(nums)) max(nums, na.rm = TRUE) + 1L else 1L
  sprintf("%s%06d", prefix, start + seq_len(n) - 1L)
}

# 批量分配并把新行写回表，返回带 id 的 tibble
assign_and_insert <- function(con, prefix, table, id_col, rows_df) {
  if (nrow(rows_df) == 0) return(rows_df)
  ids <- next_id(con, prefix, table, id_col, n = nrow(rows_df))
  rows_df[[id_col]] <- ids
  dbAppendTable(con, table, as.data.frame(rows_df))
  rows_df
}

# ---- 安全数值/日期解析 ----
to_num <- function(x) suppressWarnings(as.numeric(x))
to_int <- function(x) suppressWarnings(as.integer(x))
to_date <- function(x) suppressWarnings(as.Date(x))

# 校验和（用于 release manifest）—— 用系统 shasum，避免新依赖
file_sha256 <- function(path) {
  if (!file.exists(path)) return(NA_character_)
  if (nzchar(Sys.which("shasum"))) {
    out <- system2("shasum", c("-a", "256", path), stdout = TRUE)
    sub("\\s.*$", "", out[1])
  } else if (nzchar(Sys.which("sha256sum"))) {
    out <- system2("sha256sum", path, stdout = TRUE)
    sub("\\s.*$", "", out[1])
  } else {
    NA_character_
  }
}

message("[helpers] loaded. ROOT = ", ROOT)
