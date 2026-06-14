# 抽取操作指南 (How to Extract)

本指南说明如何用 `05_extraction_raw/` 和 `06_extraction_verified/` 的模板，把一篇红外相机文献变成可入库的结构化记录。配套检查清单见 `../camera_trap_literature_to_database_workflow.md` §18。

---

## 0. 开始前的前置（Setup Gate）
- [ ] Zotero Desktop 已启动，本地 API 可用（localhost:23119）
- [ ] OneFind 已索引 Zotero + 项目文件夹
- [ ] 文献已在 Zotero，有 item key、DOI/URL、全文/附录状态

## 1. 流程：从文献到候选表（4 个状态）

```
queued → machine-extracted(ai_candidate) → human-verified → database-ingested
```

1. **queued**：在 `04_screening/screening_decisions.csv` 标 `fulltext_include`，在 `02_zotero/literature_registry.csv` 标 `extract:queued`。
2. **ai_candidate**：用 Codex/Claude（提示词见 workflow.md §11）读 PDF/附录，输出候选行到 `05_extraction_raw/ai_candidate_tables/`。AI 只生成候选，不写真值。
3. **human-verified**：人工核验高影响字段后，复制到 `06_extraction_verified/`，`verification_status=verified`。
4. **database-ingested**：清洗脚本把 verified 表导入 DuckDB，在 `literature_registry.csv` 标 `extract:database_ingested`。

## 2. 每篇文献的文件命名与 ID
- 文献 ID：`SRC` + 6 位（如 `SRC000142`），在 `literature_registry.csv` 分配。
- 候选表文件名：`SRC000142_20260613_extraction_raw.xlsx`（多 sheet）或拆成各 `*_ai_candidate.csv` 追加行。
- study/site/deployment id 同样在抽取时分配（`STU000001 / SITE000001 / DEP000001`）。

## 3. 抽取顺序（按 schema.md §9 优先级）
1. `source` → 2. `study`/`site` → 3. `deployment` → 4. `species_inventory`/`metrics` →
5. `observation`/`independent_event`（若有原始数据） → 6. `disturbance` → 7. 附录表
> 附录优先级高于正文摘要：正文"共记录 X 种"但附录有完整表，以附录为主、正文交叉校验。

## 4. 跨表必保字段（缺失必须用缺失码，不得留空）
- **文献溯源**：标题(原文+英译)、作者、年、期刊、类型、DOI、URL、语言、zotero_item_key、检索批次、全文/附录状态
- **精确时间**：study_start/end、deployment_start/end、date_precision、camera_days、valid_nights、timestamp、season
- **空间地点**：latitude、longitude、coordinate_precision、coordinate_uncertainty_m、省/市/县、保护区名+类型、海拔、生境、survey_area_km2（≠保护区总面积）

## 5. AI 抽取标准提示词（详见 workflow.md §11，摘要）
要求 AI 检查：研究地点/经纬度/海拔/生境/调查面积；相机数/位点/布设/型号/诱饵；起止日期/季节/相机工作日/故障天数；物种名录(中文名+学名+类群+独立记录+照片/视频+RAI)；占域/密度/活动节律/人为干扰；土地利用/历史预期/红色名录/功能性状；独立记录定义(30/60min)。每个字段给页码/表号/附录；缺失标 NR/UNK/NA，禁止编造。

## 6. 人工核验强制项（Gate 4）
物种名录、经纬度、相机工作日、相机数、监测日期、面积、独立记录阈值、红色名录类别、密度、任何"未探测/缺失"推断 —— 这些不允许只有 AI 未核验值。

## 7. 出现问题时
记入 `12_audits/` 或在对应 verified 表的 `notes` 标注；物种/地点不确定进 `07_cleaning/` 的 crosswalk；全文不可得进 `01_search/no_full_text_reason.csv`。
