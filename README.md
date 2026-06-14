# TW-CVII China — 红外相机脊椎动物完整性研究

本仓库同时承载 **研究工作流系统** 与 **公开学术网站**。

## 研究工作流系统

从文献检索到标准化数据库的可复现证据生产线。核心文档（单一真源）：

- `camera_trap_literature_to_database_workflow.md` — 文献检索到标准化数据库工作流（18 节）
- `camera_trap_database_schema_predicts_divert_twcvii.md` — PREDICTS/DiVert/TW-CVII 数据库字段规范（23 表 + 4 视图）
- `TW-CVII_China_Proposal_20260613_workflow_optimized.docx` — 研究提案（真源，含公式与阈值）
- `红外相机研究工作流_整理优化版_20260613.docx` — 两份 markdown 整理优化合并版（便于阅读）

### 目录骨架（已就绪，含模板）

```text
00_admin/        决策记录、变更日志、数据来源使用政策
01_search/       检索策略、search_log、导出清单、引文追踪、无全文原因
02_zotero/       literature_registry（Zotero key ↔ 抽取状态）
03_full_text/    pdf_manifest、supplementary_manifest
04_screening/    筛选决策、排除原因受控词表
05_extraction_raw/  HOW_TO_EXTRACT 指南 + ai_candidate_tables（含样例行）+ 附录抽取
06_extraction_verified/  人工核验后的 source/study/site/deployment/species_inventory/metrics/audit
07_cleaning/     taxonomy/location crosswalk、metric 定义、清洗规则
08_database/     schema 指针 + 4 版数据库发布清单
09_analysis/     scripts / notebooks / outputs
10_figures_tables/  可复现图表
11_manuscripts/  论文 claim 模板
12_audits/       QA Gate 报告、citation-claim 审计
```

### 快速上手
1. 读 `05_extraction_raw/HOW_TO_EXTRACT.md` 了解抽取流程
2. 每篇文献在 `02_zotero/literature_registry.csv` 分配 `SRC000xxx`
3. AI 候选写入 `05_extraction_raw/ai_candidate_tables/`（含样例行可参照）
4. 人工核验后移入 `06_extraction_verified/`
5. 清洗脚本导入 DuckDB，按 `08_database/schema.md` 发布版本

数据边界（敏感坐标/受版权全文不入公开库）见 `00_admin/source_use_policy.md`。

## 公开网站（GitHub Pages）

This repository also hosts a bilingual GitHub Pages website for the Threat-weighted Camera-trap Vertebrate Intactness Index for China project.

## Website Modules

- `Research`: proposal, evidence states, and TW-CVII conceptual framework.
- `Workflow`: literature search, Zotero/OneFind knowledge base, AI-assisted extraction, verification, standardization, and QA gates.
- `Database`: PREDICTS / DiVert / Camtrap DP-aligned camera-trap database schema.
- `Analysis`: TW-CVII analysis views, protected-area comparison, silent-range and monitoring-gap outputs.

## Executable Workflow

The repository now contains a working candidate workflow base:

- `08_database/schema/tables.json`: machine-readable relational schema.
- `08_database/schema/critical_field_dictionary.md`: required literature, locality, coordinate, time, camera-effort, species, and disturbance fields.
- `08_database/templates/*.csv`: standardized extraction templates.
- `05_extraction_raw/prompts/camera_trap_extraction_prompt.md`: AI/manual extraction prompt.
- `09_analysis/scripts/generate_workflow_templates.py`: regenerate CSV headers.
- `09_analysis/scripts/load_seed_qingliangfeng.py`: load the first open PDF seed extraction.
- `09_analysis/scripts/validate_workflow.py`: structural QA gate validator.
- `09_analysis/scripts/build_sqlite_database.py`: build a local SQLite candidate database.
- `08_database/releases/camera_trap_candidate.sqlite`: current candidate database release.

Current seed extraction:

- `SRC000001`: Guo et al. 2022, Zhejiang Qingliangfeng National Nature Reserve.
- Candidate rows: 1 source, 1 study, 3 blocks, 4 sites, 4 deployment aggregates, 54 species, 54 species-site RAI measurements, 5 disturbance records.
- Important caveat: values are `candidate`; Appendix 1, Zotero item key, external taxonomy, and high-impact fields still require human verification.

Run the executable workflow:

```bash
python3 09_analysis/scripts/generate_workflow_templates.py --force
python3 09_analysis/scripts/load_seed_qingliangfeng.py
python3 09_analysis/scripts/validate_workflow.py --report
python3 09_analysis/scripts/build_sqlite_database.py
```

## Local Preview

```bash
python3 -m http.server 8080
```

Open:

```text
http://localhost:8080/
```

## Public Site

Expected GitHub Pages URL:

```text
https://dingchenchen6.github.io/tw-cvii-camera-trap-china/
```

## Data Boundary

This public site does not publish raw copyrighted PDFs, Zotero local data, restricted datasets, exact sensitive wildlife coordinates, private notes, or raw camera media. It publishes only the research framework, workflow, schema, non-sensitive examples, and analysis plan.

## Source Frameworks

- Camtrap DP: https://camtrap-dp.tdwg.org/data/
- GBIF camera-trap guide: https://docs.gbif.org/camera-trap-guide/en/
- PREDICTS database: https://doi.org/10.1002/ece3.2579
- DiVert: https://doi.org/10.1111/geb.70261
