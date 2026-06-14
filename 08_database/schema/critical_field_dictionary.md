# TW-CVII 红外相机数据库关键字段字典

版本：2026-06-14  
状态：candidate workflow field dictionary  
用途：规定文献抽取、AI 提取、人工核验、标准化数据库入库时必须优先保障的字段。

## 1. 文献信息字段

每一篇文章、报告、学位论文、数据集或附录都必须进入 `source` 表。不得只保存 PDF 文件名。

必采字段：

| 字段 | 表 | 说明 |
|---|---|---|
| `source_id` | `source` | 文献唯一编号，例如 `SRC000001` |
| `zotero_item_key` | `source` | Zotero item key；Zotero 未运行时暂记 `PENDING_ZOTERO` |
| `bibtex_key` | `source` | Better BibTeX 或项目内部引用键 |
| `title_original` | `source` | 原文题名 |
| `title_english` | `source` | 英文题名、英文摘要题名或人工译名 |
| `authors` | `source` | 全部作者 |
| `corresponding_author` | `source` | 通讯作者，未报告用 `NR` |
| `affiliations` | `source` | 作者单位 |
| `year` / `publication_date` | `source` | 发表年和完整发表日期 |
| `journal_or_source` | `source` | 期刊、报告来源、数据集平台 |
| `journal_volume` / `journal_issue` / `pages` | `source` | 卷、期、页码 |
| `doi` / `cstr` / `url` | `source` | DOI、CSTR、landing page URL |
| `pdf_file_id` | `source` | 关联 `pdf_manifest.file_id` |
| `abstract` / `keywords` | `source` | 摘要和关键词 |
| `database_source` | `source` | CNKI、WOS、Wanfang、VIP、Google Scholar、journal website 等 |
| `search_id_first_found` | `source` | 首次发现该文献的检索批次 |
| `full_text_status` | `source` | available / missing / restricted |
| `supplement_status` | `source` | none / available / missing / appendix_referenced_needs_check |
| `citation_text` | `source` | 可用于论文写作的标准引文 |

质量要求：

- DOI、URL、题名、作者、年份不得缺失；确实无 DOI 时用 `NR` 并保留 URL。
- Zotero 未接入前，`zotero_item_key` 必须保持 `PENDING_ZOTERO`，后续统一补齐。
- 附录或补充材料被正文引用时，`supplement_status` 不能写 `none`。

## 2. 地名与空间字段

红外相机文献常同时包含保护区名、片区名、样区、网格、相机位点和坐标范围。必须分层保存，不能把保护区范围误当作相机点坐标。

### 2.1 区组字段

`block` 表用于记录保护区片区、山系、管理分区、样区组等。

必采字段：

| 字段 | 表 | 说明 |
|---|---|---|
| `block_name_original` | `block` | 原文片区/样区组名称 |
| `block_name_standard` | `block` | 标准化名称 |
| `block_type` | `block` | protected_area_section / mountain_range / management_zone / grid_cluster |
| `country` / `province` / `prefecture` / `county` / `township` | `block` | 行政地名 |
| `protected_area_name` | `block` | 所属保护地 |
| `block_latitude_original` / `block_longitude_original` | `block` | 原文坐标表达 |
| `block_latitude` / `block_longitude` | `block` | 标准化十进制度，未报告用 `NR` |
| `coordinate_precision` | `block` | exact / approximate / range_reported / section_only / not_published |
| `coordinate_source` | `block` | text / table / map / appendix / author_data |

### 2.2 地点字段

`site` 表用于记录保护区、片区、样区、网格或汇总调查地点。

必采字段：

| 字段 | 表 | 说明 |
|---|---|---|
| `site_name_original` | `site` | 原文地点名 |
| `site_name_standard` | `site` | 标准地点名 |
| `locality_original` | `site` | 原文完整地名描述 |
| `protected_area_name` / `protected_area_section` | `site` | 保护地和片区 |
| `country` / `province` / `prefecture` / `county` / `township` / `village_or_station` | `site` | 行政和局地地名 |
| `mountain_range` / `river_basin` / `ecoregion` | `site` | 山系、流域、生态区 |
| `latitude_original` / `longitude_original` | `site` | 原文坐标字符串 |
| `latitude` / `longitude` | `site` | 十进制度点坐标；只有范围时填 `NR` |
| `coordinate_precision` | `site` | exact / approximate / range_reported / section_only / not_published |
| `coordinate_uncertainty_m` | `site` | 坐标不确定度 |
| `coordinate_source` | `site` | 正文、表、图、附录、作者数据 |
| `coordinate_datum` | `site` | WGS84 / GCJ02 / CGCS2000 / NR |
| `geometry_type` / `geometry_wkt` | `site` | range / polygon / point / grid；可选 WKT |
| `coordinate_sensitive_flag` | `site` | 是否敏感坐标 |
| `coordinate_access_level` | `site` | public_range / blurred / restricted / exact_private |
| `elevation_min_m` / `elevation_max_m` / `elevation_mean_m` | `site` | 海拔 |
| `survey_area_km2` | `site` | 调查面积，不等于保护区总面积时必须区分 |
| `protected_area_total_km2` | `site` | 保护区总面积 |
| `habitat_type_original` / `habitat_type_standard` | `site` | 生境类型 |

质量要求：

- 如果文献只给保护区坐标范围，`latitude` 和 `longitude` 不得伪造成中心点，除非另有 `coordinate_derivation_rule`。
- 保护区总面积和实际调查面积必须分开。
- 相机位点精确坐标涉及敏感物种时，不得公开发布；数据库内部使用访问级别控制。

## 3. 时间字段

时间字段必须保留原文表达和标准化表达。中文文献常写“2017 年 12 月至 2019 年 11 月”，不能强行转成具体日。

### 3.1 文献与流程时间

| 字段 | 表 | 说明 |
|---|---|---|
| `date` | `search_log` | 检索日期 |
| `download_date` | `pdf_manifest` / `supplementary_manifest` | 下载日期 |
| `publication_date` | `source` | 发表日期 |
| `extraction_date` | `extraction_audit` | 抽取日期 |
| `verification_date` | `extraction_audit` | 人工核验日期 |
| `created_date` / `resolved_date` | `issue_log` | 问题登记和解决日期 |

### 3.2 调查与部署时间

| 字段 | 表 | 说明 |
|---|---|---|
| `study_start_date_original` / `study_end_date_original` | `study` | 原文调查起止时间 |
| `study_start_date` / `study_end_date` | `study` | 标准化日期；可为 YYYY、YYYY-MM 或 YYYY-MM-DD |
| `survey_years` / `survey_months` / `survey_duration_days` | `study` | 调查年份、月数、天数 |
| `sample_date_resolution` | `study` | year / month / day / exact_datetime |
| `survey_season_scope` | `study` | dry / wet / breeding / winter / multi-season |
| `deployment_start_original` / `deployment_end_original` | `deployment` | 原文相机布设时间 |
| `deployment_start` / `deployment_end` | `deployment` | 标准化相机布设起止 |
| `deployment_date_resolution` | `deployment` | month / day / exact |
| `active_days` / `camera_days` / `valid_nights` | `deployment` | 有效工作天、相机工作日、有效夜 |
| `check_interval_months` | `deployment` | 检查或换卡间隔 |
| `capture_datetime` / `observation_datetime` / `event_start` | `media` / `observation` / `independent_event` | 原始数据足够细时记录 |

质量要求：

- 原文只有月份时，标准化日期写 `YYYY-MM`，不要擅自补成月初或月末。
- `survey_duration_days` 只有能明确计算时才填数值；否则填 `NR` 并保留 `survey_months`。
- `camera_days` 必须记录分母和公式来源，RAI 不能只保存结果。

## 4. 红外相机努力量与物种字段

必须优先保障：

- `total_camera_count_reported`
- `total_station_count_reported`
- `camera_model`
- `grid_size_km`
- `camera_days`
- `malfunction_days`
- `independent_event_threshold`
- `species_original`
- `scientific_name_original`
- `scientific_name_accepted`
- `independent_records`
- `valid_photos`
- `rai_original`
- `rai_per_100_camera_days`
- `occupancy`
- `density`
- `activity_pattern_available`

## 5. 缺失码

任何空值都要尽量用受控缺失码解释：

| 代码 | 含义 |
|---|---|
| `NR` | 文献未报告 |
| `NA` | 不适用 |
| `UNK` | 无法判断 |
| `PENDING` | 待核验 |
| `EXTRACTED_UNVERIFIED` | 已抽取但未人工核验 |
| `RESTRICTED` | 受权限限制 |

## 6. 当前种子样例状态

`SRC000001` 清凉峰文章已完成 candidate 级抽取：

- 文献信息：已填 DOI、题名、作者、期刊、卷期页、URL、关键词。
- 地名：已填中国、浙江、杭州、临安区、清凉峰国家级自然保护区、千顷塘/龙塘山/顺溪坞片区。
- 经纬度：只填原文保护区坐标范围，标准十进制度点坐标暂记 `NR`，避免伪精度。
- 时间：已填 2017 年 12 月至 2019 年 11 月，标准化为 `2017-12` 到 `2019-11`。
- 红外相机努力量：已填 115 个位点、30,993 相机工作日、1 km 网格。
- 物种：已填 54 个候选物种记录和 RAI。
- 待解决：Zotero item key、附录 1、外部分类学核验、人工复核。
