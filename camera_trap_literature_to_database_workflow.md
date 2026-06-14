# 红外相机文献到标准化数据库工作流

版本：2026-06-13  
适用项目：TW-CVII / 中国红外相机文献、监测报告、附录与补充数据抽取  
目标：从“全面检索和下载红外相机相关文献”到“构建可追溯、可复核、可分析、可写论文的标准化数据库”

---

## 0. 核心原则

本工作流不是普通文献综述流程，而是面向红外相机数据库建设的证据生产线。每条最终数据都必须能追溯到：检索批次、文献条目、PDF/CAJ/附录文件、页码或表号、抽取人或 AI 工具、人工核验状态、清洗规则和数据库版本。

不可妥协的原则：

1. 文献检索必须多轮、多库、多关键词、多语言，不能只用一个关键词或一个数据库。
2. 下载必须合法合规，优先开放获取、机构授权、作者公开附件和期刊补充材料。
3. Zotero 是文献元数据与全文附件的主入口；OneFind 是本地全文知识库检索层。
4. AI 抽取只是“候选数据生成”，不能直接成为数据库真值。
5. 原始文献、原始附件、原始抽取表永不覆盖；清洗和标准化必须由脚本生成。
6. 红外相机核心字段必须优先保障，按四类记忆：
   - **文献溯源信息**：标题（原文+英译）、作者、发表年、期刊/报告/数据集来源、文献类型、DOI/URL、语言、Zotero item key、首次检索批次、全文与附录状态。
   - **精确时间**：研究起止日期、相机布设起止（deployment_start/end）、季节、监测时段、监测时长、相机工作日、有效夜数、独立记录的时间戳与活动节律。
   - **空间与地点**：经纬度（WGS84）、坐标精度与不确定性、省/市/县/乡镇、保护区/国家公园名及类型、生态红线状态、海拔、生境、调查面积（与保护区总面积分开）。
   - **生态指标**：相机数量、相机位点、有效照片/视频、独立有效记录、物种名录（中文名+学名）、相对多度/多度/丰度（RAI）、占域/密度/活动节律、人为干扰记录。
   其中**经纬度、文献溯源信息、精确时间**属于“即便文献只给汇总值也要尽量还原或标注精度”的高优先字段，缺失时必须用缺失码（NR/UNK/centroid 等）显式记录，不得静默留空。
7. 附录、补充表、图中表格、地图、物种清单图片和 PDF 扫描件必须纳入抽取范围。
8. 任何“未记录”“未报告”“无法判断”“不适用”必须用标准缺失码区分。

推荐对齐标准：

- Camtrap DP 将红外相机数据组织为 `deployments`、`media`、`observations` 三类核心资源，适合作为本数据库的技术骨架参考。
- GBIF camera-trap guide 强调红外相机数据管理、质量控制、开放 FAIR 和部署/媒体/观测信息的可复用性。
- PREDICTS 的关键价值是 `Source -> Study -> Block -> Site -> Measurement` 分层结构、采样方法可比性、采样努力量、土地利用压力和分类学标准化。
- DiVert 的关键价值是把局地脊椎动物丰度/多样性记录与土地利用、管理实践、参考基线、采样方法、努力量和样方面积系统连接。
- 本项目不能只复制 PREDICTS 或 DiVert；必须额外加入历史分布、当代探测、调查充分性、红色名录、功能性状和 TW-CVII 证据状态。
- Zotero 官方建议优先从文章 landing page 使用 Zotero Connector 保存，以获得更高质量元数据，并在可访问时自动保存 PDF。
- Web of Science Marked List 支持导出 EndNote、RIS、Excel、Tab-delimited 等格式，适合批量进入 Zotero 或筛选表。

参考来源见文末“来源与依据”。

---

## 1. 项目目录结构

> 说明：本目录结构为整个项目的唯一结构规范，`camera_trap_database_schema_predicts_divert_twcvii.md` 第 9 节“抽取优先级”中引用的 `08_database/`、`07_cleaning/` 等路径即指此处的同名文件夹，两份文档共用同一套目录。

建议在项目根目录建立如下结构：

```text
00_admin/
  project_decisions.md
  workflow_change_log.md
  source_use_policy.md
01_search/
  search_strategy.md
  search_log.csv
  database_export_manifest.csv
  query_snapshots/
02_zotero/
  zotero_collection_plan.md
  references.bib
  zotero_export_snapshots/
03_full_text/
  pdf_manifest.csv
  no_full_text_reason.csv
  supplementary_manifest.csv
04_screening/
  screening_decisions.csv
  exclusion_reasons_controlled_vocab.md
05_extraction_raw/
  extraction_batch_manifest.csv
  ai_candidate_tables/
  manual_candidate_tables/
  appendix_extractions/
06_extraction_verified/
  source_verified.csv
  study_site_verified.csv
  deployment_verified.csv
  species_inventory_verified.csv
  metrics_verified.csv
  extraction_audit.csv
07_cleaning/
  cleaning_rules.md
  taxonomy_crosswalk.csv
  location_crosswalk.csv
  metric_definitions.csv
08_database/
  schema.md
  camera_trap_v0_raw_ingest.duckdb
  camera_trap_v1_cleaned_core.duckdb
  camera_trap_v2_analysis_ready.duckdb
  camera_trap_v3_manuscript_freeze.duckdb
09_analysis/
  scripts/
  notebooks/
  outputs/
10_figures_tables/
11_manuscripts/
12_audits/
  qa_gate_reports/
  citation_claim_audits/
```

文件命名规则：

```text
YYYYMMDD_database_query_round.csv
SRC000123_20260613_extraction_raw.xlsx
SRC000123_appendix_table_S2_species_inventory.csv
camera_trap_v1_clean_20260613.duckdb
ms1_claim_audit_20260613.csv
```

---

## 2. Setup Gate：Zotero、OneFind、项目仓库

在正式检索和抽取前完成一次设置门槛。

### 2.1 Zotero

目标：Zotero 成为文献元数据、附件、标签、笔记和引用键的 source of truth。

推荐 collection 结构：

```text
TW-CVII China Camera Trap
  00_seed_reviews_and_standards
  01_china_camera_trap_surveys
  02_species_inventory_and_raI
  03_occupancy_density_activity
  04_human_disturbance_livestock_dogs
  05_protected_areas_national_parks
  06_historical_distribution_redlist_traits
  07_methods_and_data_standards
  08_excluded_after_full_text
  09_missing_full_text
```

推荐 Zotero tags：

```text
screen:new
screen:title_abstract_include
screen:title_abstract_exclude
screen:fulltext_include
screen:fulltext_exclude
extract:queued
extract:ai_candidate
extract:human_verified
extract:database_ingested
source:cnki
source:wos
source:biodiversity_science
source:google_scholar
source:report
data:appendix
data:supplementary_excel
data:species_inventory
data:rai
data:occupancy
data:density
data:activity
data:human_disturbance
quality:high
quality:needs_check
```

Zotero 操作规范：

1. 优先从文章 landing page 用 Zotero Connector 保存，不优先直接拖 PDF。
2. 如果只有 PDF，拖入 Zotero 后检查是否成功创建 parent item。
3. 每条 included 文献至少包含：标题、作者、年份、期刊/报告来源、DOI 或 URL、语言、摘要、附件状态。
4. 中文文献要补齐中文题名、英文题名（如有）、期刊中文名、DOI、页码。
5. 每周导出 `references.bib` 或用 Better BibTeX 自动导出。

当前本机状态记录：

- Zotero local API 偏好已开启。
- Zotero Desktop 当前未运行，因此 `localhost:23119` 暂不可用。
- 生产抽取前需要启动 Zotero 并确认 API 或 Connector 可用。

### 2.2 OneFind

目标：OneFind 作为本地全文知识库，用于跨 Zotero、PDF、附录、项目文件夹快速检索证据块。

设置门槛：

1. 配置 Zotero SQLite 或 Zotero 数据目录。
2. 配置项目文件夹作为只读知识源，至少包括 `03_full_text/`、`05_extraction_raw/`、`06_extraction_verified/`、`11_manuscripts/`。
3. 刷新索引。
4. 用已知文献测试，例如 `Xiao 2022 camera-trapping China Biodiversity Science`。

当前本机状态记录：

- OneFind 已安装。
- 当前还未配置 Zotero 或 folder knowledge source。
- 向量索引部分可用但不完整；正式检索前建议完成数据源配置并刷新。

---

## 3. 文献检索总策略

检索目标不是“找到一些相关文献”，而是尽可能覆盖中国红外相机文献中可用于数据库建设的文章、报告、附录和补充数据。

### 3.1 数据库和来源范围

第一优先级：

- Web of Science Core Collection
- CNKI / 中国知网
- 万方
- 维普
- Google Scholar
- Biodiversity Science / 生物多样性
- Acta Theriologica Sinica / 兽类学报
- National Park / 国家公园相关期刊
- Journal of Ecology / Chinese Journal of Applied Ecology / Chinese Journal of Zoology 等中文生态动物期刊

第二优先级：

- Scopus（如有权限）
- Crossref
- GBIF dataset search
- DataOne / Zenodo / Figshare / Dryad
- 保护区、国家公园、林草局、生态环境部、科研院所和高校报告
- 论文参考文献反向追踪
- 被引文献追踪

第三优先级：

- 学位论文
- 地方自然保护区综合科学考察报告
- 项目结题报告
- 会议论文和摘要
- 数据平台说明文档

### 3.2 检索轮次

至少执行 7 轮检索。每一轮都要保存检索式、数据库、日期、结果数、导出文件和备注。

| 轮次 | 目的 | 典型关键词 |
|---|---|---|
| R1 广泛召回 | 最大化红外相机相关文献 | 红外相机、自动相机、相机陷阱、camera trap |
| R2 物种编目 | 找物种清单、鸟兽资源、兽类多样性 | 物种多样性、物种编目、鸟兽资源、兽类资源 |
| R3 丰度/多度 | 找 RAI、多度、相对丰度、活动强度 | 相对多度指数、RAI、relative abundance |
| R4 方法与努力量 | 找相机数量、相机工作日、监测时长 | camera days、trap nights、监测时长、相机工作日 |
| R5 空间对象 | 找保护区、国家公园、山系、县域 | 自然保护区、国家公园、山地、流域、省名 |
| R6 目标类群 | 找兽类、地栖鸟类、食肉动物、家畜干扰 | 大中型兽类、地栖鸟类、Carnivora、livestock |
| R7 追踪补漏 | 被引、参考文献、同作者、同区域补漏 | 核心综述参考文献、forward citation |

---

## 4. 检索词矩阵

### 4.1 中文核心词

技术词：

```text
红外相机
红外触发相机
自动相机
自动触发相机
相机陷阱
相机捕获
野生动物监测
红外相机监测
红外相机调查
红外监测
```

对象词：

```text
兽类
鸟兽
鸟类
地栖鸟类
大中型兽类
哺乳动物
食肉动物
有蹄类
雉类
国家重点保护野生动物
受威胁物种
旗舰物种
伞护物种
```

指标词：

```text
物种多样性
物种编目
物种组成
物种丰富度
相对多度
相对多度指数
多度
丰度
占域
占域模型
密度
活动节律
日活动
时间生态位
人为干扰
家畜
放牧
犬
人类活动
```

努力量和设计词：

```text
相机数量
相机位点
相机工作日
有效相机日
监测时长
监测时间
布设
网格
样线
样地
监测面积
调查面积
海拔
生境
保护区
国家公园
```

地理词：

```text
中国
全国
省名
县名
自然保护区
国家级自然保护区
国家公园
生态红线
山系
秦岭
横断山
三江源
东北虎豹
海南热带雨林
武夷山
```

### 4.2 英文核心词

```text
camera trap
camera trapping
camera-trapping
infrared camera
infrared-triggered camera
wildlife monitoring
mammal diversity
ground-dwelling birds
species inventory
species richness
relative abundance index
RAI
trap nights
camera days
sampling effort
occupancy
detection probability
activity pattern
human disturbance
livestock
domestic dog
protected area
nature reserve
national park
China
```

---

## 5. 推荐检索式

### 5.1 Web of Science / Scopus 英文检索式

宽检索：

```text
TS=("camera trap*" OR "camera-trap*" OR "camera trapping" OR "infrared camera*" OR "automatic camera*")
AND TS=(China OR Chinese OR "Hong Kong" OR Taiwan OR Tibet OR Xinjiang OR Yunnan OR Sichuan OR Qinghai)
```

红外相机 + 物种编目：

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("species inventory" OR "species richness" OR biodiversity OR "mammal diversity" OR "bird diversity")
AND TS=(China OR "nature reserve" OR "national park" OR "protected area")
```

红外相机 + 努力量/多度：

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("relative abundance index" OR RAI OR "camera day*" OR "trap night*" OR "sampling effort" OR abundance OR density OR occupancy)
AND TS=(China OR Chinese)
```

红外相机 + 人为干扰：

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("human disturbance" OR "human activity" OR livestock OR grazing OR "domestic dog*" OR road*)
AND TS=(China OR "protected area" OR "national park")
```

红外相机 + 中国保护地：

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("protected area*" OR "nature reserve*" OR "national park*" OR "ecological redline")
AND TS=(China OR Chinese)
```

### 5.2 CNKI / 万方 / 维普中文检索式

宽检索：

```text
("红外相机" OR "自动相机" OR "相机陷阱" OR "红外触发相机")
AND ("野生动物" OR "兽类" OR "鸟兽" OR "鸟类")
```

物种编目：

```text
("红外相机" OR "自动相机" OR "相机陷阱")
AND ("物种多样性" OR "物种组成" OR "物种编目" OR "鸟兽资源" OR "兽类资源")
```

多度/丰度/相对多度：

```text
("红外相机" OR "自动相机")
AND ("相对多度" OR "相对多度指数" OR "多度" OR "丰度" OR "RAI" OR "活动节律")
```

努力量：

```text
("红外相机" OR "自动相机")
AND ("相机工作日" OR "有效相机日" OR "监测时长" OR "调查时间" OR "相机数量" OR "布设")
```

空间/保护地：

```text
("红外相机" OR "自动相机")
AND ("自然保护区" OR "国家公园" OR "保护地" OR "生态红线" OR "保护区")
```

人为干扰：

```text
("红外相机" OR "自动相机")
AND ("人为干扰" OR "人类活动" OR "家畜" OR "放牧" OR "犬" OR "牧业")
```

地区补漏：

```text
("红外相机" OR "自动相机")
AND ("省名" OR "山系名" OR "保护区名" OR "国家公园名")
```

### 5.3 追踪检索

核心综述必须做 backward/forward citation chasing：

1. Xiao et al. 2022 中国红外相机监测与研究综述。
2. Li et al. 2014 红外相机技术在我国野生动物研究与保护中的应用与前景。
3. 中国野生动物红外相机监测统一标准相关文献。
4. Camtrap DP 和 GBIF camera trap guide。
5. 各国家公园/保护区红外相机调查代表性论文。

追踪记录格式：

```csv
seed_source_id,seed_citation,method,platform,date,records_found,records_imported,notes
SRC000001,Xiao 2022,backward_reference,WOS,2026-06-13,108,87,screen duplicates
SRC000001,Xiao 2022,forward_citation,Google Scholar,2026-06-13,36,28,manual export
```

---

## 6. 下载和全文管理

### 6.1 下载优先级

1. 期刊官网开放 PDF 和补充材料。
2. 机构授权访问 PDF。
3. CNKI/万方/维普授权下载 CAJ/PDF。
4. 作者主页、ResearchGate、机构知识库中公开 PDF。
5. DOI landing page 的 supplementary information。
6. 数据仓库：GBIF、Dryad、Figshare、Zenodo、Science Data Bank。
7. 无法下载时记录 `no_full_text_reason.csv`，不要悄悄丢弃。

### 6.2 PDF/CAJ/附录清单

`pdf_manifest.csv` 字段：

```text
file_id
source_id
zotero_item_key
filename
file_type
source_url
access_route
download_date
checksum_sha256
stored_or_linked
ocr_required
ocr_status
has_supplementary
full_text_status
legal_use_status
notes
```

`supplementary_manifest.csv` 字段：

```text
supplement_id
source_id
zotero_item_key
supplement_type
filename
source_url
table_or_sheet_names
contains_species_inventory
contains_camera_effort
contains_raw_records
contains_coordinates
contains_environment
extraction_priority
checksum_sha256
notes
```

---

## 7. 筛选标准

### 7.1 纳入标准

纳入文献需满足至少一项：

1. 在中国境内使用红外相机/自动相机/相机陷阱调查野生动物。
2. 提供物种名录、独立有效照片/记录、RAI、多度、丰度、密度、占域、活动节律或人为干扰指标。
3. 提供相机数量、相机工作日、监测时段、监测地点、调查面积等可用于标准化数据库的努力量信息。
4. 提供历史分布、保护区监测、国家公园监测或红外相机数据平台信息。
5. 是方法学、数据标准、监测规范或综述，对字段定义或清洗规则有帮助。

### 7.2 排除标准

排除或降级的情况：

1. 只讨论设备广告、产品评测，没有野生动物监测数据。
2. 只提到红外摄影或热红外遥感，但不是地面红外相机/相机陷阱。
3. 研究地点不在中国，且不提供方法标准参考价值。
4. 没有可核验来源或疑似重复发表。
5. PDF/全文长期不可得，且题录信息不足以判断变量。

### 7.3 筛选状态

```text
screen:new
screen:title_abstract_include
screen:title_abstract_exclude
screen:fulltext_include
screen:fulltext_exclude
screen:method_reference_only
screen:awaiting_full_text
screen:duplicate
```

---

## 8. 字段体系总览

字段分级：

- M：Mandatory，数据库核心必填。缺失则不能进入 analysis-ready。
- H：High priority，强推荐。缺失可入库但必须解释。
- O：Optional，可选。存在则抽取。
- D：Derived，脚本派生字段，不手工填写最终值。

缺失码：

```text
NR = not reported 文献未报告
NA = not applicable 不适用
UNK = unknown 无法判断
PENDING = 待核验
EXTRACTED_UNVERIFIED = 已抽取未核验
```

### 8.1 Proposal、PREDICTS、DiVert 和 Camtrap DP 的整合层级

本 proposal 的数据库采用四层结构：

```text
Layer A: 文献和证据来源
source -> search_record -> zotero_item -> full_text/supplement

Layer B: PREDICTS/DiVert 式生态研究层级
source -> study -> block -> site -> measurement

Layer C: Camtrap DP 式红外相机技术层级
site -> deployment -> media -> observation -> independent_event

Layer D: TW-CVII 分析层
historical_expectation + contemporary_evidence + survey_adequacy
-> evidence_state
-> species_intactness / threat_weighted_intactness / functional_intactness
```

主 workflow 下方的第 9 节给出核心抽取表。更完整、可直接建库的字段规范见：

```text
camera_trap_database_schema_predicts_divert_twcvii.md
```

该字段规范新增了 `block`、`land_use_management`、`media`、`observation`、`independent_event`、`taxonomy`、`conservation_status`、`functional_traits`、`species_site_measurement`、`diversity_summary`、`historical_expectation`、`survey_adequacy_detection`、`evidence_state`、`reference_baseline_pair`、`environmental_covariates`、`protected_area_context` 和 `derived_index` 等表。

---

## 9. 核心数据表和字段

注意：本节是文献抽取的最小核心表，适合从 PDF/附录快速进入候选数据库。正式执行 TW-CVII proposal 时，以 `camera_trap_database_schema_predicts_divert_twcvii.md` 作为 analysis-ready schema。

### 9.1 source 文献来源表

| 字段 | 等级 | 类型 | 说明 |
|---|---:|---|---|
| source_id | M | string | SRC000001 |
| zotero_item_key | M | string | Zotero item key |
| bibtex_key | H | string | Better BibTeX citekey |
| title_original | M | string | 原文题名 |
| title_english | H | string | 英文题名或译名 |
| authors | M | string | 作者 |
| year | M | integer | 发表年 |
| journal_or_source | M | string | 期刊/报告/学位论文 |
| publication_type | M | enum | article/report/thesis/book/chapter/dataset |
| doi | H | string | DOI |
| url | H | string | landing page |
| language | M | enum | zh/en/mixed |
| abstract | H | text | 摘要 |
| database_source | M | enum | CNKI/WOS/Wanfang/VIP/GoogleScholar/etc. |
| full_text_status | M | enum | available/missing/restricted |
| supplement_status | M | enum | none/available/missing/unknown |
| extraction_status | M | enum | queued/ai_candidate/human_verified/ingested |
| notes | O | text | 备注 |

### 9.2 search_record 检索记录表

| 字段 | 等级 | 说明 |
|---|---:|---|
| search_id | M | 检索批次编号 |
| round | M | R1-R7 |
| database | M | 数据库 |
| query_string | M | 完整检索式 |
| search_date | M | 日期 |
| searcher | M | 人或 agent |
| result_count | M | 命中数 |
| exported_count | H | 导出数 |
| export_file | H | RIS/BibTeX/CSV 文件 |
| deduped_count | H | 去重后数 |
| notes | O | 说明 |

### 9.3 study 项目/研究表

| 字段 | 等级 | 说明 |
|---|---:|---|
| study_id | M | STU000001 |
| source_id | M | 对应文献 |
| study_name | H | 项目或研究名称 |
| study_objective | H | 物种编目/活动节律/保护评估等 |
| target_taxa | M | mammals/birds/both/other |
| survey_design | H | grid/transect/opportunistic/mixed |
| target_species | O | 若为目标物种研究 |
| study_start_date | H | 研究起始 |
| study_end_date | H | 研究结束 |
| total_camera_count_reported | H | 文献报告的相机数 |
| total_station_count_reported | H | 位点数 |
| total_camera_days_reported | H | 总相机工作日 |
| total_area_reported | H | 调查面积 |
| area_unit_original | H | km2/ha/其他 |
| independent_event_threshold | H | 30 min/60 min/文献定义 |
| bait_lure_use | H | yes/no/NR |
| notes | O | 备注 |

### 9.4 site 空间地点表

| 字段 | 等级 | 说明 |
|---|---:|---|
| site_id | M | SITE000001 |
| study_id | M | 所属研究 |
| site_name_original | M | 原文地点名 |
| protected_area_name | H | 保护区/国家公园名 |
| province | M | 省 |
| prefecture | H | 市/州 |
| county | H | 县 |
| latitude | H | 纬度 |
| longitude | H | 经度 |
| coordinate_precision | H | exact/centroid/approx/unknown |
| elevation_min_m | O | 最低海拔 |
| elevation_max_m | O | 最高海拔 |
| habitat_type_original | H | 原文生境 |
| habitat_type_standard | D | 标准生境 |
| survey_area_km2 | H | 标准化面积 |
| area_source | H | 文献/地图/估算 |
| protection_status | H | national park/nature reserve/etc. |
| iucn_pa_category | O | 若可得 |
| notes | O | 备注 |

### 9.5 deployment 相机布设/努力量表

| 字段 | 等级 | 说明 |
|---|---:|---|
| deployment_id | M | DEP000001 |
| study_id | M | 所属研究 |
| site_id | M | 所属地点 |
| station_id | H | 相机位点 |
| camera_id | O | 相机编号 |
| camera_model | O | 型号 |
| deployment_start | H | 开始日期 |
| deployment_end | H | 结束日期 |
| active_days | H | 有效天数 |
| camera_days | H | 相机工作日 |
| valid_nights | O | 有效夜数 |
| malfunction_days | O | 故障天数 |
| camera_height_cm | O | 高度 |
| camera_spacing_m | O | 间距 |
| grid_size_km | O | 网格尺寸 |
| placement_type | H | trail/ridge/water/road/random/etc. |
| bait_lure_use | H | yes/no/NR |
| season | H | dry/wet/spring/summer/autumn/winter |
| extraction_page | M | 页码/表号 |
| verification_status | M | verified/unverified |

如果文献只报告总努力量，不提供每台相机信息，则使用汇总 deployment：

```text
deployment_id = DEP_SUMMARY_SRC000001_SITE000001
station_id = NR
camera_days = 文献总相机工作日
```

### 9.6 species_inventory 物种编目表

| 字段 | 等级 | 说明 |
|---|---:|---|
| inventory_id | M | INV000001 |
| source_id | M | 文献 |
| study_id | M | 研究 |
| site_id | M | 地点 |
| species_original | M | 原文物种名 |
| chinese_name | H | 中文名 |
| scientific_name_original | H | 原文学名 |
| scientific_name_accepted | D | 标准学名 |
| taxon_rank | H | species/genus/family |
| class | H | Mammalia/Aves/etc. |
| order | H | 目 |
| family | H | 科 |
| detection_confirmed | M | yes/no |
| independent_records | H | 独立有效记录 |
| valid_photos | H | 有效照片数 |
| valid_videos | O | 有效视频数 |
| individual_count | O | 个体数/最小个体数 |
| rai_original | H | 原文 RAI |
| rai_per_100_camera_days | D | 标准化 RAI |
| occupancy | O | 占域 |
| density | O | 密度 |
| activity_pattern_available | H | yes/no |
| china_redlist_category | H | CR/EN/VU/NT/LC/DD/NR |
| iucn_category | O | IUCN 类别 |
| national_protection_class | O | 国家一级/二级 |
| endemic_status | O | 是否特有 |
| extraction_page | M | 页码/表号/附录 |
| verification_status | M | verified/unverified |

### 9.7 metrics 指标表

| 字段 | 等级 | 说明 |
|---|---:|---|
| metric_id | M | MET000001 |
| source_id | M | 文献 |
| study_id | M | 研究 |
| site_id | H | 地点 |
| species_id | H | 物种，可为 all |
| metric_name_original | M | 原文指标名 |
| metric_name_standard | M | RAI/species_richness/occupancy/density/activity_overlap/etc. |
| metric_value_original | M | 原值 |
| metric_unit_original | H | 原单位 |
| metric_value_standard | D | 标准化值 |
| metric_unit_standard | D | 标准单位 |
| denominator | H | camera_days/independent_records/area |
| formula_reported | H | 原文公式 |
| uncertainty | O | SE/CI/SD |
| extraction_page | M | 来源页码/表号 |
| notes | O | 说明 |

### 9.8 disturbance 人为干扰表

| 字段 | 等级 | 说明 |
|---|---:|---|
| disturbance_id | M | DIS000001 |
| source_id | M | 文献 |
| study_id | M | 研究 |
| site_id | H | 地点 |
| disturbance_type_original | M | 原文类型 |
| disturbance_type_standard | M | human/livestock/dog/vehicle/grazing/hunting/etc. |
| independent_records | H | 独立记录 |
| valid_photos | H | 照片数 |
| rai_per_100_camera_days | D | 标准化 RAI |
| temporal_overlap_species | O | 与哪种动物重叠 |
| extraction_page | M | 页码 |
| notes | O | 说明 |

### 9.9 extraction_audit 抽取审计表

| 字段 | 等级 | 说明 |
|---|---:|---|
| audit_id | M | AUD000001 |
| source_id | M | 文献 |
| file_id | M | PDF/CAJ/附录 |
| extraction_batch | M | 批次 |
| extractor | M | human/codex/claude/other |
| extraction_date | M | 日期 |
| pages_checked | M | 页码范围 |
| tables_checked | H | 表号 |
| figures_checked | H | 图号 |
| appendix_checked | M | yes/no |
| supplement_checked | M | yes/no |
| high_impact_fields_verified | M | yes/no |
| unresolved_fields | H | 字段列表 |
| confidence | M | high/medium/low |
| verifier | H | 人工核验人 |
| verification_date | H | 日期 |
| notes | O | 备注 |

### 9.10 TW-CVII proposal 必需分析表

以下表用于从“红外相机文献数据库”升级为“可执行 proposal 研究的完整数据库”。详细字段见 `camera_trap_database_schema_predicts_divert_twcvii.md`。

| 表 | 用途 | 必须解决的问题 |
|---|---|---|
| `block` | PREDICTS 式空间区组 | 同一 study 内地点是否存在空间聚集或分层 |
| `land_use_management` | DiVert 式土地利用和管理实践 | primary/secondary/cropland/pasture/forestry/urban、管理强度、放牧、道路、人为干扰 |
| `media` | Camtrap DP 媒体层 | 若有原始图片/视频，保留文件、时间戳、公开状态 |
| `observation` | Camtrap DP 观测层 | animal/human/vehicle/blank，物种、个体数、行为、性别年龄 |
| `independent_event` | 独立事件层 | 30/60 min 等阈值后的独立记录 |
| `taxonomy` | 分类学骨架 | 原文名、接受名、中文名、目科属种、同物异名 |
| `conservation_status` | 红色名录和保护等级 | 中国红色名录、IUCN、国家保护等级、威胁权重 |
| `functional_traits` | 功能性状 | 体型、食性、功能类群、栖息地专化、功能权重 |
| `species_site_measurement` | PREDICTS Measurement 核心表 | species x site 的 abundance/occurrence/RAI/occupancy/density |
| `diversity_summary` | site 级多样性汇总 | richness、Shannon、总独立记录、稀释丰富度 |
| `historical_expectation` | 历史分布基线 | 某物种在某空间单元是否历史预期存在 |
| `survey_adequacy_detection` | 调查充分性和探测 | 未探测是否能解释为调查不足 |
| `evidence_state` | 四类证据状态 | confirmed persistence / silent range / monitoring gap / newly confirmed occurrence |
| `reference_baseline_pair` | DiVert 式参考比较 | 低干扰参考地、保护区核心区、历史基线、配对比较 |
| `environmental_covariates` | 环境和人为压力 | 海拔、气候、土地覆盖、人类足迹、道路距离 |
| `protected_area_context` | 保护地背景 | 保护地类型、等级、边界距离、功能区 |
| `derived_index` | TW-CVII 指数结果 | 物种完整性、威胁加权、功能加权、silent range 比例 |

### 9.11 Proposal 最低可执行字段

> 权威定义见 `camera_trap_database_schema_predicts_divert_twcvii.md` 第 8 节，此处不再重复字段列表，以免两份文档不同步。下文为简化说明。

若目标是执行 TW-CVII 主分析，每条 `species_id × spatial_unit_id × baseline_scenario` 至少需要：物种身份与空间单元、历史预期状态及置信度、当代探测及最近探测年份、调查充分性、证据状态、中国红色名录类别及威胁权重、功能类群及功能权重、相机工作日或充分性评分、地点/保护地/省坐标、来源溯源信息（完整字段清单见上述 schema 第 8 节）。

缺少上述字段时，该记录只能进入覆盖缺口、文献编目或方法参考分析，不能进入主 TW-CVII 指数计算。

---

## 10. 附录和补充材料抽取规则

红外相机文章的关键数据经常不在正文，而在：

- 附录物种名录
- Supplementary Table S1/S2
- Excel 附表
- PDF 扫描表格
- 图中地图或图注
- 保护区报告附件
- 学位论文附录

抽取顺序：

1. 下载并登记所有 supplementary files。
2. 建立 `supplementary_manifest.csv`。
3. 对 PDF 附录运行 OCR 或表格识别。
4. 对 Excel 附录保留原始 sheet，不覆盖。
5. 将每个附录表拆成 tidy table。
6. 每一行保留 `source_id`、`supplement_id`、`sheet_name`、`table_number`、`row_number_original`。
7. 不确定的物种名、单位、地点必须进入 `issue_log.csv`。

附录优先抽取字段：

```text
species list
scientific names
Chinese names
independent detections
valid photos/videos
RAI
camera station count
camera days
survey period
site coordinates
elevation
habitat
human/livestock/dog records
activity time records
```

---

## 11. AI 抽取标准提示词

对每篇文献使用如下提示词框架。输出必须为结构化表格，不接受只给摘要。

```text
你是红外相机生态学数据库抽取员。请从这篇文献及其附录中提取可用于标准化红外相机数据库的字段。

必须检查：
1. 正文方法、结果、表格、图注、附录、补充 Excel/PDF。
2. 研究地点、保护区/国家公园、经纬度、海拔、生境、调查面积。
3. 相机数量、相机位点数、布设方式、网格/样线、相机型号、是否诱饵。
4. 监测开始/结束日期、季节、有效监测时长、相机工作日、故障天数。
5. 物种名录：中文名、学名、类群、独立有效记录、照片/视频数、RAI、多度/丰度。
6. 占域、密度、活动节律、人为干扰、家畜、犬、人类活动等指标。
7. 土地利用和管理实践：原文生境、主要土地利用、利用强度、放牧、道路、采伐、农田或人为干扰。
8. 历史预期和当代证据：是否历史预期存在、是否当代探测、最近探测年份、未探测是否调查充分。
9. 红色名录和功能性状：受威胁等级、国家保护等级、体型、食性、功能类群、栖息地专化。
10. 独立记录定义，例如 30 min 或 60 min。
11. 缺失字段必须标注 NR/UNK/NA，不要猜测。

输出：
- source_summary
- study_site_table
- deployment_effort_table
- species_inventory_table
- species_site_measurement_table
- land_use_management_table
- historical_expectation_candidate_table
- survey_adequacy_candidate_table
- evidence_state_candidate_table
- metrics_table
- disturbance_table
- appendix_checked_table
- unresolved_issue_table

每个字段都要给出页码、表号或附录文件名。
不要编造未报告的数据。不要把推断当作原文数据。
```

---

## 12. 清洗和标准化规则

### 12.1 分类学

1. 保留原文名 `species_original`。
2. 标准化中文名、学名、目、科。
3. 同物异名进入 `taxonomy_crosswalk.csv`。
4. 不能确认到 species 时，保留 genus/family 级别，不强行填 species。
5. 家畜、犬、人类记录不进入野生动物物种丰富度，但进入 disturbance 表。

### 12.2 日期和努力量

1. 日期统一 ISO：`YYYY-MM-DD`。
2. 只报告月份时：`date_precision = month`，日期可填月初但必须标注。
3. 相机工作日优先使用文献原值。
4. 若文献未给总相机工作日，但给相机数和天数，可派生：

```text
camera_days_derived = camera_count * active_days - malfunction_days
```

5. 派生值必须标注 `effort_source = derived`。

### 12.3 面积

1. 所有面积标准化为 km2。
2. ha 转换：`km2 = ha / 100`。
3. 只给保护区总面积时，不等同于相机有效调查面积，字段分开：

```text
protected_area_total_km2
survey_area_km2
effective_sampling_area_km2
```

### 12.4 RAI / 多度 / 丰度

统一记录原文公式。常见标准化：

```text
RAI = independent_records / camera_days * 100
```

注意：

- RAI 不等于真实 abundance。
- 不同独立记录阈值的 RAI 不可直接混合。
- 若文献用 `照片数 / 相机日 * 100`，必须记录 `rai_numerator = valid_photos`。
- 若文献用 `独立记录 / 相机日 * 100`，记录 `rai_numerator = independent_records`。

### 12.5 地点

1. 经纬度统一 WGS84。
2. 只给保护区名时，坐标可用保护区 centroid，但 `coordinate_precision = centroid`。
3. 只给县/山系时，不直接生成精确点位。
4. 保护区边界和行政区要单独字段，不混成地点名。

---

## 13. 数据库发布版本

数据库发布版本与 TW-CVII proposal 一致，采用 **4 个版本**，命名与 `camera_trap_database_schema_predicts_divert_twcvii.md` 第 7 节统一：

| 版本 | 内容 | 可用于分析 |
|---|---|---|
| v0_raw_ingest | 原始导入、AI 候选抽取、未清洗 | 否 |
| v1_cleaned_core | 人工核验后的抽取表；标准化字段、缺失码、单位转换、分类学清洗、外键可连接 | 部分（覆盖缺口、文献编目） |
| v2_analysis_ready | 加入派生指标、空间 join、Red List/traits/environment、evidence_state、survey_adequacy | 是 |
| v3_manuscript_freeze | 论文提交版冻结数据库，配校验和与质量报告 | 是，论文必须引用此版本 |

说明：

- 早期草稿中的 `v0_raw / v1_verified / v2_clean / v3_analysis_ready / v4_manuscript_freeze`（5 版）已废弃，统一为上表 4 版，避免与 proposal 冲突。
- 人工核验与清洗合入 `v1_cleaned_core`，不再单列 `v1_verified` 与 `v2_clean` 两步，但核验与清洗仍在 Gate 4/Gate 5 分别把关。

每次发布必须包含：

```text
database_file
schema_version
record_counts_by_table
checksum
change_log
known_limitations
qa_report
```

---

## 14. 质量控制门槛

### Gate 1：检索完整性

通过条件：

- 至少完成 R1-R7 检索轮次。
- 每个数据库有检索式和结果数。
- 核心综述已做前向/后向追踪。
- 中文和英文关键词都用过。

### Gate 2：Zotero 入库

通过条件：

- included 文献都有 Zotero item。
- DOI/URL/题名/年份/来源完整。
- PDF/CAJ/全文状态明确。
- 附录状态明确。
- 去重完成。

### Gate 3：全文和附录

通过条件：

- 正文 PDF/CAJ 已登记。
- 补充材料已登记。
- 无法下载的文献有原因。
- OCR 或表格识别状态明确。

### Gate 4：抽取

通过条件：

- source、study、site、deployment、species_inventory、metrics 至少有候选表。
- 页码/表号/附录来源完整。
- 高影响字段人工核验：相机数、相机工作日、监测时段、地点、面积、物种清单、RAI。

### Gate 5：清洗

通过条件：

- 缺失码规范。
- 日期、面积、坐标、RAI 单位标准化。
- taxonomy crosswalk 完成。
- 主键唯一，外键可连接。

### Gate 6：分析前冻结

通过条件：

- `v2_analysis_ready` 数据库生成（论文提交时进一步冻结为 `v3_manuscript_freeze`）。
- 表记录数和校验和输出。
- 数据质量报告输出。
- 重大 unresolved issue 为 0 或有明确限制说明。

---

## 15. 分析与绘图输出

最小分析输出：

1. 文献检索 PRISMA 风格流程图。
2. 文献年份、地区、期刊来源分布。
3. 中国省级/保护区级红外相机研究覆盖图。
4. 相机数量、相机工作日、监测时长分布。
5. 物种丰富度和 RAI 数据可得性。
6. 物种-地点矩阵。
7. 受威胁物种记录矩阵。
8. 人类/家畜/犬干扰记录矩阵。
9. 数据缺失热图。
10. 适合 TW-CVII 的 analysis-ready 子集。

### 15.1 区分 silent range 与 monitoring gap 的量化阈值

区分 silent range 与 monitoring gap 是 TW-CVII 的概念核心，抽取和清洗时必须保留足够信息支撑以下判定（源自 proposal §6.2，临时最低值来自累计探测概率曲线）：

| 类群 | 临时最低相机工作日 | 临时最低相机位点数 | 其他要求 |
|---|---:|---:|---|
| 中型食肉动物 mesocarnivores | ≥ 1,000 | ≥ 15 | 跨季节 |
| 大型食肉动物 large carnivores | ≥ 5,000 | ≥ 30 | 跨 ≥ 12 个月 |
| 中型有蹄类、地栖鸟类 | ≥ 600–800 | ≥ 10–12 | — |

- 抽取 `deployment` 表时务必保留可派生这些阈值的字段（`camera_days`、`station_count`、季节、跨年信息），不可在清洗阶段丢失。
- 类群阈值将基于物种累积曲线和探测频率曲线经验校正；敏感性分析检验 silent-range 图对替代阈值的稳健性。
- 在调查不充分的空间单元不得生成 silent_range（schema §10 第 7 条），只能记为 monitoring_gap 或 PENDING。

### 15.2 红色名录权重与 DD 物种处理

抽取 `conservation_status` 与 `functional_traits` 时须按下列规则保留权重依据：

- 主权重序列采用几何级数（近似 ~50 年灭绝概率，与 EDGE / RLI 传统一致）：`LC = 1, NT = 2, VU = 4, EN = 8, CR = 16`。
- **DD 物种不进入 TW-CVII 主分母**，而作为独立的“知识赤字覆盖指数（Data-Deficiency Coverage Index）”分析层——数据缺乏本身是保护关注，不能默认低风险。
- 备选权重方案（线性 1–5、二次 1/4/9/16/25、基于文献灭绝风险先验的贝叶斯权重）须做敏感性分析，因此抽取时保留 `china_redlist_category` 原值，不预先归并。

### 15.3 气候位移过滤分类器

为区分气候驱动的范围重新定位与人为去动物化，证据状态判定须接入气候位移过滤（proposal §6.5，参考 Chen et al. 2011, Science）：

- 使用 1950s–2020s 气候常态，判断空间单元的气候包络是否已移出某物种的历史热生态位。
- 若 silent_range 落在气候包络已显著漂移的空间单元，标记为 `climate_explainable`，与人为去动物化区分。
- 因此 `environmental_covariates` 表须保留可重建气候包络的协变量（温度、降水等）及其年份与分辨率。

---

## 16. 论文写作连接

每篇论文建立：

```text
manuscript_id
database_version
analysis_script_version
figure_list
table_list
claim_table
references.bib snapshot
claim_reference_audit.csv
```

论文中的每个关键声明必须能连接到：

1. 数据库版本。
2. 分析脚本。
3. 图表输出。
4. 文献来源。
5. PDF 页码或附录表号。

---

## 17. 可作为 Codex Skill 的任务模式

后续可把本流程封装成 skill，并支持以下任务：

```text
Use $camera-trap-database-workflow to design a CNKI/WOS search strategy for China camera-trap species inventory papers.
Use $camera-trap-database-workflow to audit whether this extraction sheet contains all mandatory camera-trap fields.
Use $camera-trap-database-workflow to extract deployment effort and species inventory fields from this PDF.
Use $camera-trap-database-workflow to generate a standardized schema for a camera-trap literature database.
Use $camera-trap-database-workflow to check whether RAI, camera-days and survey duration are consistently standardized.
```

---

## 18. 每篇文献抽取检查清单

```text
# 文献溯源信息（必填，缺失须记原因）
[ ] Zotero item exists + zotero_item_key recorded
[ ] 标题原文 + 英译题名（如有）
[ ] 作者、发表年、期刊/报告来源、文献类型
[ ] DOI/URL checked（缺失须记 NR）
[ ] 语言（zh/en/mixed）
[ ] PDF/CAJ downloaded or missing reason recorded
[ ] Supplementary materials checked
[ ] Abstract screened
[ ] Full text screened

# 精确时间（必填，精度须标注）
[ ] 研究起止日期 study_start/end（ISO，精度 day/month/year）
[ ] 相机布设起止 deployment_start/end
[ ] 季节 season
[ ] 监测时段、监测时长
[ ] 相机工作日 camera_days（原文值；若派生须标 derived）
[ ] 有效夜数 / 故障天数（如有）
[ ] 独立记录定义（30/60 min）及时间戳/活动节律（如有）

# 空间与地点（必填，坐标缺失须标精度码）
[ ] 经纬度 latitude/longitude（WGS84）
[ ] 坐标精度 coordinate_precision（exact/centroid/county/unknown）+ 不确定性
[ ] 省 / 市/州 / 县 / 乡镇
[ ] 保护区/国家公园名 + 类型 + 生态红线状态
[ ] 海拔（min/max/mean）
[ ] 生境（原文 + 标准）
[ ] 调查面积 survey_area_km2（与保护区总面积分开）

# 生态指标
[ ] 相机数量、相机位点数
[ ] 有效照片/视频
[ ] 独立有效记录
[ ] 物种名录（中文名 + 学名 + 类群）
[ ] RAI / 多度 / 丰度（记录原文公式与分母）
[ ] 占域 / 密度 / 活动节律（如有）
[ ] 人为/家畜/犬干扰记录

# 收尾
[ ] Appendix tables extracted
[ ] All high-impact fields page-referenced
[ ] Human verification complete
[ ] Issues logged
[ ] Ready for database ingest
```

---

## 来源与依据

- Camtrap DP, TDWG: https://camtrap-dp.tdwg.org/data/
- GBIF Best Practices for Managing and Publishing Camera Trap Data: https://docs.gbif.org/camera-trap-guide/en/
- PREDICTS database paper: https://doi.org/10.1002/ece3.2579
- PREDICTS database guide and field structure: https://timnewbold.github.io/PredictsIntroduction.html
- DiVert Zenodo dataset record: https://zenodo.org/records/15347789
- DiVert paper DOI: https://doi.org/10.1111/geb.70261
- Zotero Adding Items: https://www.zotero.org/support/adding_items_to_zotero
- Zotero Retrieve PDF Metadata: https://www.zotero.org/support/retrieve_pdf_metadata
- Web of Science Marked List export: https://webofscience.zendesk.com/hc/en-us/articles/20135824927505-Saving-and-Exporting-Marked-Lists
- Xiao, Z. et al. 2022. 中国野生动物红外相机监测与研究：现状及未来. https://www.biodiversity-science.net/CN/10.17520/biods.2022451
- 生态环境部《生物多样性观测技术导则 红外相机技术》编制材料: https://www.mee.gov.cn/xxgk2018/xxgk/xxgk06/202310/W020231008327604742503.pdf
