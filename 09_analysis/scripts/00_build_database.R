#!/usr/bin/env Rscript
# =============================================================================
# 00_build_database.R — 构建空的 v0_raw_ingest.duckdb
# 读取 08_database/01_schema.sql，在 DuckDB 中创建全部 23 表 + 4 视图 + 索引。
# 用法: Rscript 09_analysis/scripts/00_build_database.R
# =============================================================================
suppressPackageStartupMessages({
  library(DBI)
  library(duckdb)
})

# 路径（脚本自定位，不依赖工作目录）
SCRIPT_DIR <- tryCatch({
  args <- commandArgs(trailingOnly = FALSE)
  arg <- sub("^--file=", "", args[grep("^--file=", args)])
  if (length(arg) && nzchar(arg)) normalizePath(dirname(arg)) else "."
}, error = function(e) ".")
# fallback: assume run from project root
if (!nzchar(SCRIPT_DIR) || SCRIPT_DIR == ".") SCRIPT_DIR <- "09_analysis/scripts"
ROOT <- normalizePath(file.path(SCRIPT_DIR, "..", ".."))
SCHEMA_SQL <- file.path(ROOT, "08_database", "01_schema.sql")
DB_DIR     <- file.path(ROOT, "08_database")

stopifnot(file.exists(SCHEMA_SQL))

build_db <- function(db_path, schema_sql, label) {
  # 删除旧库以重建
  if (file.exists(db_path)) {
    file.remove(db_path)
    message(sprintf("[%s] removed existing %s", label, basename(db_path)))
  }
  con <- dbConnect(duckdb(), dbdir = db_path, read_only = FALSE)
  on.exit(dbDisconnect(con), add = TRUE)
  sql <- paste(readLines(schema_sql, encoding = "UTF-8"), collapse = "\n")
  dbExecute(con, sql)
  # 验证
  tables <- dbGetQuery(con,
    "SELECT table_name FROM information_schema.tables
     WHERE table_schema='main' AND table_type='BASE TABLE' ORDER BY table_name")
  views <- dbGetQuery(con,
    "SELECT table_name FROM information_schema.views
     WHERE table_schema='main' ORDER BY table_name")
  message(sprintf("[%s] created %d tables, %d views at %s",
                  label, nrow(tables), nrow(views), basename(db_path)))
  message("  tables: ", paste(tables$table_name, collapse = ", "))
  message("  views : ", paste(views$table_name, collapse = ", "))
  invisible(list(tables = tables, views = views))
}

v0 <- file.path(DB_DIR, "camera_trap_v0_raw_ingest.duckdb")
res <- build_db(v0, SCHEMA_SQL, "v0_raw_ingest")

message("\n✓ 空数据库构建完成：", v0)
message("  下一步：运行 01_seed_taxonomy.R 填入常用物种，再用 03_clean.R + 04_ingest.R 入库数据。")
