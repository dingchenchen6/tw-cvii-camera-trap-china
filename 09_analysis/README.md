# 09_analysis — 数据库构建与分析管线 (DuckDB + R)

从 verified CSV 到 analysis-ready 数据库的可复现管线。按编号顺序运行。

## 管线脚本（按顺序）

| 脚本 | 作用 | 输入 | 输出 |
|---|---|---|---|
| `scripts/00_build_database.R` | 建空库（23 表 + 4 视图 + 索引） | `08_database/01_schema.sql` | `v0_raw_ingest.duckdb` |
| `scripts/01_helpers.R` | 共享工具（路径常量、ID 分配器、缺失码）— 被 source() | — | — |
| `scripts/02_seed_reference.R` | 填参考表（taxonomy/conservation/functional） | `07_cleaning/seed_taxonomy.csv` | 写入 v0 |
| `scripts/03_ingest.R` | 清洗 verified CSV 并入库 | `06_extraction_verified/seed_*.csv` | `v1_cleaned_core.duckdb` |
| `scripts/05_derive.R` | 派生调查充分性、证据状态、TW-CVII 指数 | v1 | `v2_analysis_ready.duckdb` |
| `scripts/06_qa_gates.R` | 跑 schema §10 + workflow §14 质量门 | v2 | `12_audits/qa_gate_reports/` |
| `scripts/07_release_manifest.R` | 生成发布清单（记录数 + 校验和） | 全部版本 | `08_database/database_release_manifest.csv` |

## 一键重跑

```bash
cd <项目根>
Rscript 09_analysis/scripts/00_build_database.R
Rscript 09_analysis/scripts/02_seed_reference.R
Rscript 09_analysis/scripts/03_ingest.R
Rscript 09_analysis/scripts/05_derive.R
Rscript 09_analysis/scripts/06_qa_gates.R
Rscript 09_analysis/scripts/07_release_manifest.R
```

> duckdb 二进制文件（`.duckdb`）已加入 `.gitignore`（可由脚本重建）；仓库只存可重建的 SQL + R + CSV。

## 当前种子数据（2026-06-13）

| 项 | 值 |
|---|---|
| 文献 | Zhao W et al. 2026, BDJ 14:e184017（CC-BY 4.0，黄山九龙峰）|
| 物种 | 15 种哺乳动物（5 目 10 科）|
| measurement | 30 条（15 物种 × {independent_records, RAI}）|
| 调查充分性 | 3 条（3 类群阈值；mammals baseline 充分：7964 cd ≥ 1000, 32 站 ≥ 15）|
| 证据状态 | 15 条（全部 confirmed_persistence）|
| 已知缺口 | historical_expectation 空；部分物种缺 conservation_status；site 坐标=centroid |

## 如何接入新文献

1. 把 PDF 放 `03_full_text/`，题录入 `02_zotero/literature_registry.csv` 分配 `SRC0000xx`
2. `pdftotext` 提取文本到 `05_extraction_raw/text/`
3. 填 `06_extraction_verified/` 对应表（参照 `05_extraction_raw/HOW_TO_EXTRACT.md`）
4. 重跑 `03_ingest.R`（会增量追加，不重建参考表）→ `05_derive.R` → `06_qa_gates.R`

## 依赖
R ≥ 4.5；包：`DBI duckdb dplyr readr stringi janitor`（+ `pdftools targets` 可选）。
系统：`pdftotext`、`shasum`（macOS 自带）、DuckDB CLI（可选，`brew install duckdb`）。
