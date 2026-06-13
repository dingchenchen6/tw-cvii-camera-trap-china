# 数据库 Schema (指针)

**完整字段规范见 `../camera_trap_database_schema_predicts_divert_twcvii.md`（单一真源）。**

本目录存放实际数据库文件与发布清单：

- `camera_trap_v0_raw_ingest.duckdb` — 原始导入、AI 候选、未清洗
- `camera_trap_v1_cleaned_core.duckdb` — 人工核验 + 清洗 + 外键可连接
- `camera_trap_v2_analysis_ready.duckdb` — 加派生指标、空间 join、Red List/traits/environment、evidence_state
- `camera_trap_v3_manuscript_freeze.duckdb` — 论文提交冻结版
- `database_release_manifest.csv` — 每次发布的版本/校验和/记录数/已知限制

## 表清单（共 23 表 + 4 视图，定义见 schema.md）
source, study, block, site, land_use_management, deployment, media, observation,
independent_event, taxonomy, conservation_status, functional_traits,
species_site_measurement, diversity_summary, historical_expectation,
survey_adequacy_detection, evidence_state, reference_baseline_pair,
environmental_covariates, protected_area_context, derived_index, extraction_audit, issue_log

视图：view_species_site_evidence, view_site_intactness_inputs,
view_pa_effectiveness_inputs, view_redlist_mismatch_inputs

## 字段等级与缺失码
- M 必填 / H 高优先 / O 可选 / D 派生（脚本生成，不手填最终值）
- 缺失码：NR / NA / UNK / PENDING / EXTRACTED_UNVERIFIED / RESTRICTED
