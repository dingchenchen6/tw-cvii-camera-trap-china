#!/usr/bin/env Rscript
# =============================================================================
# 04_import_inbox.R — Zotero 导入自动化
#   你把 Zotero 导出的 RIS/BibTeX + 同名 PDF 拖进 03_full_text/import_inbox/
#   本脚本: 解析题录 → 分配 SRC ID → 注册 literature_registry → 提取文本
#           → 生成 verified source CSV 行(填好题录) → PDF 归档
#   之后你/我只需补 study/site/species 抽取,重跑 03_ingest.R 即可入库。
#
#   文件命名(任选其一):
#     (a) RIS/BibTeX 与 PDF 同名:  mypaper.ris + mypaper.pdf
#     (b) 文件名即 Zotero citekey:  zhao2026huangshan.pdf (+ .ris 可选)
#
#   用法: Rscript 09_analysis/scripts/04_import_inbox.R
# =============================================================================
source("09_analysis/scripts/01_helpers.R")
suppressPackageStartupMessages(library(dplyr))

INBOX   <- file.path(ROOT, "03_full_text", "import_inbox")
TEXTOUT <- file.path(ROOT, "05_extraction_raw", "text")
ARCHIVE <- file.path(ROOT, "03_full_text")
REG_CSV <- file.path(ROOT, "02_zotero", "literature_registry.csv")
SRC_CSV <- file.path(ROOT, "06_extraction_verified", "seed_sources.csv")
dir.create(INBOX, showWarnings = FALSE, recursive = TRUE)
dir.create(TEXTOUT, showWarnings = FALSE, recursive = TRUE)
existing_src <- function() {
  if (file.exists(SRC_CSV)) {
    d <- read.csv(SRC_CSV, stringsAsFactors=FALSE)
    nums <- as.integer(gsub("\\D","",d$source_id))
    m <- max(nums, na.rm=TRUE)
    if (is.finite(m)) return(m)
  }
  0L
}
next_src <- existing_src() + 1L
message(sprintf("[import_inbox] 下一可用 SRC 号: SRC%06d", next_src))

# ---- 扫描 inbox: 找所有 .ris/.bib/.txt(题录) 与 .pdf ----
bib_files <- list.files(INBOX, pattern = "\\.(ris|bib|txt|ciw|enw)$",
                        ignore.case = TRUE, full.names = TRUE)
pdf_files <- list.files(INBOX, pattern = "\\.pdf$", ignore.case = TRUE, full.names = TRUE)

if (length(bib_files)==0 && length(pdf_files)==0) {
  message("inbox 为空。把 Zotero 导出的 RIS/BibTeX + PDF 拖进:\n  ", INBOX,
          "\n再重跑本脚本。文件命名见脚本头注释。")
  quit(status=0)
}

# ---- 简易 RIS/BibTeX 解析(取标题/作者/年/期刊/DOI/URL/语言) ----
parse_record <- function(path) {
  txt <- paste(readLines(path, encoding="UTF-8", warn=FALSE), collapse="\n")
  ext <- tolower(tools::file_ext(path))
  getf <- function(re) {
    m <- regmatches(txt, regexec(re, txt, perl=TRUE))[[1]]
    if (length(m)>=2) trimws(m[2]) else NA_character_
  }
  if (ext %in% c("ris","ciw","enw")) {
    # RIS: TY/TI/AU/PY/JF/DO/UR/LA ; CIW: PT/TI/AU/Py/SO/DO/UT/LA
    list(
      title = getf("(?:TI|T1|Title)\\s+-\\s+(.+)"),
      authors = paste(na.omit(unlist(regmatches(txt, gregexpr("(?:AU|A1)\\s+-\\s+.+", txt)))) , collapse="; "),
      year = getf("(?:PY|Y1|Py)\\s+(?:-\\s+)?(\\d{4})"),
      journal = getf("(?:JF|JO|JA|SO|JOURNAL)\\s+(?:-\\s+)?(.+)"),
      doi = getf("(?:DO|DO)\\s+(?:-\\s+)?(10\\.[^\\s,]+)"),
      url = getf("(?:UR|UT)\\s+(?:-\\s+)?(.+)"),
      language = getf("(?:LA|LA)\\s+(?:-\\s+)?(.+)")
    )
  } else {
    # BibTeX: @type{key, title={..}, author={..}, year={..}, journal={..}, doi={..}
    list(
      title = getf("title\\s*=\\s*[\\{\"](.+?)[\\}\"]"),
      authors = getf("author\\s*=\\s*[\\{\"](.+?)[\\}\"]"),
      year = getf("year\\s*=\\s*[\\{\"]?(\\d{4})"),
      journal = getf("journal\\s*=\\s*[\\{\"](.+?)[\\}\"]"),
      doi = getf("doi\\s*=\\s*[\\{\"](.+?)[\\}\"]"),
      url = getf("url\\s*=\\s*[\\{\"](.+?)[\\}\"]"),
      language = getf("language\\s*=\\s*[\\{\"](.+?)[\\}\"]")
    )
  }
}

# 配对: 题录文件 ↔ PDF(同名 stem)
stem <- function(p) tools::file_path_sans_ext(basename(p))
records <- list()
for (b in bib_files) {
  rec <- parse_record(b)
  rec$bib_file <- b
  rec$pdf_file <- pdf_files[match(stem(b), stem(pdf_files))]
  rec$pdf_file <- if (is.na(rec$pdf_file)) NA_character_ else rec$pdf_file
  records[[length(records)+1]] <- rec
}
# 有 PDF 但无题录的: 从文件名注册(占位,后续手补)
for (p in pdf_files) {
  if (!stem(p) %in% stem(bib_files)) {
    records[[length(records)+1]] <- list(
      title=stem(p), authors=NA, year=NA, journal=NA, doi=NA, url=NA,
      language="zh", bib_file=NA, pdf_file=p)
  }
}

# ---- 注册每条: 分配 SRC ID + 提取文本 + 写 registry/source 行 ----
new_reg_rows <- list(); new_src_rows <- list()
for (i in seq_along(records)) {
  r <- records[[i]]
  sid <- sprintf("SRC%06d", next_src + i - 1L)
  # 提取文本
  if (!is.na(r$pdf_file) && file.exists(r$pdf_file)) {
    txt_out <- file.path(TEXTOUT, paste0(stem(r$pdf_file), ".txt"))
    system2("pdftotext", c("-enc","UTF-8","-layout", r$pdf_file, txt_out),
            stdout=TRUE, stderr=TRUE)
    # 归档 PDF 到 03_full_text/
    file.rename(r$pdf_file, file.path(ARCHIVE, basename(r$pdf_file)))
  }
  lang <- if (is.na(r$language)) "zh" else
            ifelse(grepl("eng|en", tolower(r$language)), "en", "zh")
  zkey <- ifelse(is.na(r$pdf_file), paste0("MANUAL_",sid), paste0("INBOX_",sid))

  new_reg_rows[[i]] <- tibble::tibble(
    source_id=sid, zotero_item_key=zkey, bibtex_key=stem(r$bib_file %||% r$pdf_file),
    title_short=substr(r$title %||% "untitled",1,60), screening_status="included",
    extraction_status="queued", file_checksum=NA_character_,
    data_table_ids=NA_character_, notes="imported via 04_import_inbox")
  new_src_rows[[i]] <- tibble::tibble(
    source_id=sid, zotero_item_key=zkey, bibtex_key=NA_character_,
    title_original=r$title %||% NA, title_english=NA,
    authors=r$authors %||% NA, year=as.integer(r$year),
    journal_or_source=r$journal %||% NA, publication_type="article",
    doi=r$doi %||% NA, url=r$url %||% NA, language=lang,
    database_source="CNKI", search_id_first_found=NA, full_text_status=ifelse(is.na(r$pdf_file),"missing","available"),
    supplement_status="unknown", has_appendix_species_list="unknown",
    data_access_status="restricted", duplicate_group_id=NA,
    extraction_status="queued", notes="auto-registered from Zotero inbox")
  message(sprintf("✓ %s  %s  %s", sid, substr(r$title %||% "",1,40),
                  ifelse(is.na(r$pdf_file),"(no PDF)","text extracted")))
}

# 追加到 registry 与 source CSV(用 write.table append 模式,避免类型冲突)
write_reg <- function(new_rows, path) {
  cols <- c("source_id","zotero_item_key","bibtex_key","title_short",
            "screening_status","extraction_status","file_checksum",
            "data_table_ids","notes")
  df <- as.data.frame(dplyr::bind_rows(new_rows))[cols]
  if (!file.exists(path)) writeLines(paste(cols, collapse=","), path)
  con_f <- file(path, "a"); write.table(df, con_f, sep=",", row.names=FALSE,
                                        col.names=FALSE, quote=TRUE, qmethod="double"); close(con_f)
}
write_src <- function(new_rows, path) {
  cols <- c("source_id","zotero_item_key","bibtex_key","title_original","title_english",
            "authors","year","journal_or_source","publication_type","doi","url","language",
            "database_source","search_id_first_found","full_text_status","supplement_status",
            "has_appendix_species_list","data_access_status","duplicate_group_id",
            "extraction_status","notes")
  df <- as.data.frame(dplyr::bind_rows(new_rows))[cols]
  if (!file.exists(path)) writeLines(paste(cols, collapse=","), path)
  con_f <- file(path, "a"); write.table(df, con_f, sep=",", row.names=FALSE,
                                        col.names=FALSE, quote=TRUE, qmethod="double"); close(con_f)
}
write_reg(new_reg_rows, REG_CSV)
write_src(new_src_rows, SRC_CSV)

# 清理已处理的题录文件
for (b in bib_files) if (file.exists(b)) file.remove(b)
message(sprintf("\n✓ 导入完成: %d 篇文献已注册到 literature_registry + seed_sources.csv", length(records)))
message("  下一步: 补充 study/site/species 抽取(参照 HOW_TO_EXTRACT.md),然后重跑 03_ingest.R")
message("  导入的文本在: ", TEXTOUT)
