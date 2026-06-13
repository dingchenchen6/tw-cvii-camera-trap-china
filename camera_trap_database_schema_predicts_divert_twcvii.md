# 红外相机 PREDICTS/DiVert/TW-CVII 数据库字段规范

版本：2026-06-13  
适用项目：Threat-weighted Camera-trap Vertebrate Intactness Index for China (TW-CVII)  
用途：把中国红外相机文献、监测报告、附录、补充数据和派生协变量整理成可复核、可建模、可写论文的标准化关系型数据库。

---

## 1. 设计目标

本数据库不是普通物种记录库，而是一个面向 proposal 研究问题的证据数据库。它要同时支持：

1. 中国红外相机文献的全面整理和可追溯抽取。
2. 类 PREDICTS 的 `Source-Study-Block-Site-Measurement` 层级建模。
3. 类 DiVert 的土地利用、管理实践、参考基线和局地丰度/多样性比较。
4. Camtrap DP 风格的 `deployment-media-observation` 红外相机技术骨架。
5. TW-CVII 所需的历史分布、当代探测、调查充分性、受威胁权重、功能权重和证据状态分类。

最终 analysis-ready 数据库必须能回答 proposal 的核心问题：

- 历史上预期存在的物种，今天是否有当代红外相机或补充调查证据？
- 未探测到的物种是 `silent range` 还是 `monitoring gap`？
- 受威胁、大体型、食肉、栖息地专化或功能独特物种是否更容易缺失当代证据？
- 保护区、国家公园、生态红线、山系、生态区和不同土地利用/管理条件下，威胁加权和功能加权完整性是否不同？
- 红外相机研究覆盖、相机工作日、物种名录、RAI、占域、密度、活动节律和人为干扰数据的可用性在哪里不足？

---

## 2. 参照数据库逻辑

### 2.1 PREDICTS 逻辑

PREDICTS 的关键启发是分层结构和可比较采样：

```text
Source -> Study -> Block -> Site -> Measurement
```

在本数据库中的对应关系：

| PREDICTS 元素 | 本数据库对应 | 用途 |
|---|---|---|
| Source | `source` | 文献、报告、数据集来源 |
| Study | `study` | 同一来源中采样方法一致、可比较的一组调查 |
| Block | `block` | 空间聚集或分层单元，例如保护区分区、山系、样区组 |
| Site | `site` | 具体调查地点或相机阵列所在地点 |
| Measurement | `measurement` / `species_site_measurement` | 物种丰度、出现、丰富度、多样性、RAI、占域等指标 |

必须保留的 PREDICTS 风格字段：

- `source_id`
- `study_id`
- `block_id`
- `site_id`
- `measurement_id`
- `sampling_method`
- `sampling_effort`
- `sampling_effort_unit`
- `sample_start_earliest`
- `sample_end_latest`
- `sample_date_resolution`
- `sample_midpoint`
- `max_linear_extent_m`
- `land_use_type`
- `land_use_intensity`
- `taxon_name_entered`
- `taxon_name_accepted`

### 2.2 DiVert 逻辑

DiVert 的关键启发是把局地脊椎动物丰度/多样性记录和土地利用/管理实践连接起来，并尽量与 primary vegetation 或低干扰参考状态比较。

本数据库吸收以下字段类型：

- 主土地类型：primary vegetation, secondary vegetation, cropland, pasture, forestry, agroforestry, urban, mining, other。
- 管理实践：prior land use, time since conversion, crop type, crop diversity, logging type, grazing, natural margins, pesticide/fertilizer, hunting/disturbance where available。
- 采样过程：sampling method, sampling effort, plot/area size, study period, taxonomic scope。
- 丰度和多样性记录：species-level abundance/RAI/occurrence，site-level richness/Shannon/functional diversity。
- 参考比较：reference site, baseline scenario, paired comparison, log response ratio where appropriate。

对 TW-CVII 来说，DiVert 的“参考地”逻辑不应机械照搬为 primary vegetation，而应扩展为：

```text
historical_expected_assemblage
minimally_disturbed_reference_site
within-study reference site
protected-area core reference
modelled baseline
```

### 2.3 Camtrap DP 逻辑

Camtrap DP 的核心是：

```text
deployments -> media -> observations
```

本数据库必须兼容这个技术骨架，但文献抽取常常只有汇总数据。因此分两层保存：

- `deployment/media/observation/independent_event`：当文献或原始数据足够细时使用。
- `species_site_measurement/diversity_summary`：当文献只有汇总表、附录物种名录或 RAI 表时使用。

### 2.4 TW-CVII proposal 逻辑

proposal 需要的新增分析层：

```text
historical_expectation + contemporary_evidence + survey_adequacy
-> evidence_state
-> species_intactness / detection_corrected_intactness / threat_weighted_intactness / functional_intactness / abundance_proxy_intactness
```

四类证据状态：

| evidence_state | 历史预期 | 当代证据 | 调查充分性 | 解释 |
|---|---|---|---|---|
| confirmed_persistence | yes | detected | any adequate level | 物种仍有当代持续存在证据 |
| silent_range | yes | not_detected | adequate | 可能局地消失、严重衰退或低密度沉默 |
| monitoring_gap | yes | not_detected/unknown | inadequate | 不能判断是否仍存在，需要加强监测 |
| newly_confirmed_occurrence | no/uncertain | detected | any | 新记录、范围扩张、历史漏记或基线错误 |

---

## 3. 主键和层级

### 3.1 ID 规则

| ID | 示例 | 说明 |
|---|---|---|
| `source_id` | SRC000001 | 文献、报告、数据集 |
| `study_id` | STU000001 | 同一来源中的一个可比较研究 |
| `block_id` | BLK000001 | 空间区组 |
| `site_id` | SITE000001 | 调查地点 |
| `deployment_id` | DEP000001 | 相机布设 |
| `media_id` | MED000001 | 图片/视频文件 |
| `observation_id` | OBS000001 | 媒体或事件级观测 |
| `event_id` | EVT000001 | 独立事件或序列 |
| `species_id` | SP000001 | 标准物种 |
| `measurement_id` | MET000001 | 指标记录 |
| `expectation_id` | HEX000001 | 历史预期记录 |
| `evidence_id` | EVD000001 | 物种-地点证据状态 |

### 3.2 关系结构

```text
source 1--n study
study 1--n block
block 1--n site
site 1--n deployment
deployment 1--n media
deployment 1--n observation
observation n--1 species
site n--n species through species_site_measurement
site n--n species through historical_expectation
site n--n species through evidence_state
site 1--1/n land_use_management
site 1--1/n environmental_covariates
species 1--1/n taxonomy, conservation_status, functional_traits
```

---

## 4. 字段分级和缺失码

字段等级：

- `M`: Mandatory。进入 analysis-ready 的核心必填字段。
- `H`: High priority。强推荐；缺失必须写原因。
- `O`: Optional。存在则抽取。
- `D`: Derived。由脚本派生，不手工填写最终值。

缺失码：

| 代码 | 含义 |
|---|---|
| `NR` | 文献未报告 |
| `NA` | 不适用 |
| `UNK` | 无法判断 |
| `PENDING` | 待核验 |
| `EXTRACTED_UNVERIFIED` | 已抽取但未人工核验 |
| `RESTRICTED` | 可知存在但受数据权限限制 |

---

## 5. 数据表字段规范

### 5.1 `source` 文献/数据源表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `source_id` | M | 文献或数据源唯一编号 |
| `zotero_item_key` | M | Zotero item key |
| `bibtex_key` | H | Better BibTeX citekey |
| `title_original` | M | 原文题名 |
| `title_english` | H | 英文题名或译名 |
| `authors` | M | 作者 |
| `year` | M | 发表年 |
| `journal_or_source` | M | 期刊、报告、学位论文、数据集 |
| `publication_type` | M | article/report/thesis/book/chapter/dataset/preprint |
| `doi` | H | DOI |
| `url` | H | landing page |
| `language` | M | zh/en/mixed |
| `database_source` | M | CNKI/WOS/Wanfang/VIP/GoogleScholar/Zotero/manual |
| `search_id_first_found` | H | 首次发现的检索批次 |
| `full_text_status` | M | available/missing/restricted |
| `supplement_status` | M | none/available/missing/unknown |
| `has_appendix_species_list` | H | yes/no/unknown |
| `data_access_status` | H | open/by_request/restricted/extracted_from_pdf |
| `license_or_reuse_note` | O | 数据使用限制 |
| `duplicate_group_id` | H | 去重组 |
| `screening_status` | M | included/excluded/pending |
| `extraction_status` | M | queued/ai_candidate/human_verified/ingested |
| `source_quality_score` | H | 0-3，按可追溯性和数据完整性评分 |
| `notes` | O | 备注 |

### 5.2 `study` 研究表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `study_id` | M | 研究编号 |
| `source_id` | M | 来源 |
| `study_name` | H | 项目或研究名称 |
| `study_number_within_source` | H | 同一 source 内编号 |
| `study_objective` | H | 物种编目/保护评估/活动节律/占域/密度等 |
| `study_common_taxon` | M | mammals/birds/reptiles/amphibians/mixed |
| `target_taxa` | M | 目标类群 |
| `target_species` | O | 目标物种 |
| `sampling_method` | M | camera_trap/camera_trap_plus_line_transect/etc. |
| `survey_design` | H | grid/transect/random/opportunistic/paired/reference-gradient/mixed |
| `methods_constant_within_study` | H | yes/no/unknown |
| `independent_event_threshold` | H | 30 min/60 min/other |
| `sampling_occassion_definition` | H | day/week/month/custom |
| `study_start_date` | H | 开始日期 |
| `study_end_date` | H | 结束日期 |
| `sample_date_resolution` | H | day/month/year/range |
| `total_camera_count_reported` | H | 相机数量 |
| `total_station_count_reported` | H | 相机位点 |
| `total_deployment_count` | H | 布设次数 |
| `total_camera_days_reported` | H | 总相机工作日 |
| `total_valid_nights_reported` | O | 有效夜数 |
| `total_area_reported` | H | 原文面积 |
| `area_unit_original` | H | km2/ha/mu |
| `bait_lure_use` | H | yes/no/mixed/NR |
| `camera_model_reported` | O | 相机型号 |
| `raw_data_available` | H | yes/no/restricted/unknown |
| `supplementary_data_available` | H | yes/no/unknown |
| `study_quality_flags` | H | 多值，如 no_coordinates, no_effort |

### 5.3 `block` 空间区组表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `block_id` | M | 空间区组 |
| `study_id` | M | 研究 |
| `block_name_original` | H | 原文区组名 |
| `block_type` | H | reserve_zone/mountain/site_cluster/grid_cell/watershed/admin_unit/none |
| `spatial_clustering_reason` | H | PREDICTS 风格空间聚集原因 |
| `block_latitude` | O | 区组中心 |
| `block_longitude` | O | 区组中心 |
| `coordinate_precision` | H | exact/centroid/approx/unknown |
| `notes` | O | 备注 |

### 5.4 `site` 调查地点表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `site_id` | M | 地点编号 |
| `study_id` | M | 研究 |
| `block_id` | H | 空间区组 |
| `site_number_within_study` | H | 原始 site 编号 |
| `site_name_original` | M | 原文地点名 |
| `site_name_standard` | H | 标准地点名 |
| `province` | M | 省 |
| `prefecture` | H | 市/州 |
| `county` | H | 县 |
| `township` | O | 乡镇 |
| `protected_area_name` | H | 保护地名称 |
| `protected_area_id` | H | 标准保护地 ID |
| `national_park_status` | H | inside/outside/buffer/unknown |
| `latitude` | H | WGS84 |
| `longitude` | H | WGS84 |
| `coordinate_precision` | M | exact/rounded/centroid/county/protected_area/unknown |
| `coordinate_uncertainty_m` | H | 坐标不确定性 |
| `elevation_min_m` | O | 最低海拔 |
| `elevation_max_m` | O | 最高海拔 |
| `elevation_mean_m` | O | 平均海拔 |
| `habitat_type_original` | H | 原文生境 |
| `habitat_type_standard` | D | 标准化生境 |
| `survey_area_km2` | H | 实际调查面积 |
| `protected_area_total_km2` | O | 保护区总面积，不等同 survey_area |
| `effective_sampling_area_km2` | O | 有效采样面积 |
| `max_linear_extent_m` | H | 最大采样线性跨度 |
| `spatial_unit_for_twcvii` | M | site/grid/protected_area/ecoregion/mountain_system |
| `notes` | O | 备注 |

### 5.5 `land_use_management` 土地利用和管理表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `landuse_id` | M | 记录编号 |
| `site_id` | M | 地点 |
| `habitat_as_described` | H | 原文描述 |
| `predominant_land_use` | H | primary_vegetation/secondary_vegetation/cropland/pasture/forestry/agroforestry/urban/mining/other |
| `source_for_land_use` | H | original_text/map/remote_sensing/inferred |
| `use_intensity` | H | minimal/light/intense/unknown |
| `prior_land_use` | O | 转化前土地利用 |
| `time_since_conversion_years` | O | 转化后年数 |
| `secondary_vegetation_age_class` | O | young/intermediate/mature/unknown |
| `crop_type` | O | 作物类型 |
| `crop_diversity` | O | monoculture/polyculture/mixed/unknown |
| `logging_type` | O | clear_cut/selective/reduced_impact/unknown |
| `grazing_presence` | H | yes/no/unknown |
| `grazing_intensity` | O | light/moderate/heavy/unknown |
| `natural_margin_presence` | O | yes/no/unknown |
| `road_or_trail_presence` | H | yes/no/unknown |
| `hunting_or_poaching_evidence` | H | yes/no/unknown |
| `human_footprint_value` | O | 外部协变量 |
| `distance_to_road_m` | O | 外部协变量 |
| `distance_to_settlement_m` | O | 外部协变量 |
| `land_use_notes` | O | 备注 |

### 5.6 `deployment` 相机布设表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `deployment_id` | M | 布设编号 |
| `study_id` | M | 研究 |
| `site_id` | M | 地点 |
| `station_id` | H | 相机位点 |
| `location_id` | H | Camtrap DP locationID |
| `camera_id` | O | 相机设备编号 |
| `camera_model` | O | 相机型号 |
| `deployment_start` | H | ISO 日期或日期时间 |
| `deployment_end` | H | ISO 日期或日期时间 |
| `date_precision` | H | day/month/year/range |
| `active_days` | H | 有效天数 |
| `camera_days` | H | 相机工作日 |
| `trap_nights` | H | 若原文用 trap nights |
| `valid_nights` | O | 有效夜数 |
| `malfunction_days` | O | 故障天数 |
| `camera_delay_seconds` | O | 触发间隔 |
| `camera_height_cm` | O | 架设高度 |
| `camera_heading_deg` | O | 朝向 |
| `camera_tilt_deg` | O | 倾角 |
| `detection_distance_m` | O | 探测距离 |
| `camera_spacing_m` | O | 相机间距 |
| `grid_size_km` | O | 网格 |
| `placement_type` | H | trail/ridge/valley/water/road/random/animal_path/other |
| `bait_lure_use` | H | yes/no/unknown |
| `season` | H | spring/summer/autumn/winter/dry/wet/mixed |
| `timestamp_issues` | H | yes/no/unknown |
| `deployment_source_resolution` | M | station_level/site_summary/study_summary |
| `extraction_page` | M | 页码/表号/附录 |
| `verification_status` | M | verified/unverified |

### 5.7 `media` 媒体表

文献抽取通常没有原始媒体文件，但若作者公开图片/视频或数据集，应按此表保存。

| 字段 | 等级 | 说明 |
|---|---:|---|
| `media_id` | M | 媒体编号 |
| `deployment_id` | M | 布设 |
| `capture_method` | H | activityDetection/timeLapse |
| `timestamp` | H | 拍摄时间 |
| `file_path_or_url` | H | 文件路径或 URL |
| `file_public` | H | true/false |
| `file_name` | H | 文件名 |
| `file_mediatype` | H | image/jpeg/video/mp4 |
| `exif_available` | O | yes/no |
| `media_quality_flag` | O | blurred/blank/corrupt/etc. |

### 5.8 `observation` 观测表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `observation_id` | M | 观测编号 |
| `deployment_id` | M | 布设 |
| `media_id` | H | 媒体 |
| `event_id` | H | 独立事件 |
| `event_start` | H | 事件开始 |
| `event_end` | H | 事件结束 |
| `observation_level` | M | media/event |
| `observation_type` | M | animal/human/vehicle/blank/unknown/unclassified |
| `species_id` | H | 标准物种 |
| `scientific_name_original` | H | 原文学名 |
| `count` | H | 个体数 |
| `life_stage` | O | adult/subadult/juvenile |
| `sex` | O | female/male/unknown |
| `behavior` | O | walking/feeding/vigilance/etc. |
| `classification_method` | H | human/AI/mixed |
| `classification_probability` | O | AI 置信度 |
| `taxonomic_certainty` | H | certain/probable/uncertain |
| `is_independent_event` | H | yes/no |
| `independence_threshold_min` | H | 30/60/other |
| `record_source` | M | raw_media/supplementary_table/literature_summary |

### 5.9 `independent_event` 独立事件表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `event_id` | M | 事件编号 |
| `deployment_id` | M | 布设 |
| `site_id` | M | 地点 |
| `species_id` | M | 物种 |
| `event_start` | H | 开始时间 |
| `event_end` | H | 结束时间 |
| `event_date` | H | 日期 |
| `event_hour` | O | 小时 |
| `event_diel_period` | O | day/night/dawn/dusk |
| `individual_count_min` | H | 最小个体数 |
| `group_size` | O | 群体大小 |
| `behavior` | O | 行为 |
| `human_overlap_flag` | O | 是否与人类活动比较 |
| `source_resolution` | M | event_level/summary_only |

### 5.10 `taxonomy` 分类学表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `species_id` | M | 标准物种 ID |
| `taxon_name_entered` | M | 原文名 |
| `taxon_name_parsed` | H | 解析后名称 |
| `scientific_name_accepted` | H | 接受名 |
| `chinese_name_standard` | H | 标准中文名 |
| `name_status` | H | accepted/synonym/provisional/unresolved |
| `taxon_rank` | M | species/genus/family |
| `kingdom` | H | Animalia |
| `phylum` | H | Chordata |
| `class` | H | Mammalia/Aves/etc. |
| `order` | H | 目 |
| `family` | H | 科 |
| `genus` | H | 属 |
| `species` | H | 种加词 |
| `best_guess_binomial` | H | 尽可能给二名法 |
| `taxonomy_source` | H | Catalogue of Life/GBIF/中国生物物种名录/人工 |
| `taxonomy_notes` | O | 备注 |

### 5.11 `conservation_status` 保护状态表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `status_id` | M | 编号 |
| `species_id` | M | 物种 |
| `china_redlist_category` | H | CR/EN/VU/NT/LC/DD/NE |
| `china_redlist_version` | H | 2016/2020 update/etc. |
| `iucn_category` | H | IUCN 类别 |
| `iucn_version_or_year` | H | 版本/年份 |
| `national_protection_class` | H | Class I/Class II/none |
| `cites_appendix` | O | CITES |
| `endemic_status` | H | China endemic/near endemic/not endemic/unknown |
| `threat_weight` | D | TW-CVII 权重 |
| `dd_uncertainty_flag` | D | DD 物种不确定性 |

### 5.12 `functional_traits` 功能性状表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `trait_id` | M | 编号 |
| `species_id` | M | 物种 |
| `body_mass_g` | H | 体重 |
| `body_size_class` | D | small/medium/large |
| `trophic_level` | H | herbivore/omnivore/carnivore/insectivore/scavenger |
| `diet_breadth` | O | 食性宽度 |
| `foraging_stratum` | H | ground/arboreal/aerial/aquatic/mixed |
| `activity_pattern` | O | diurnal/nocturnal/cathemeral |
| `habitat_specialization` | H | specialist/generalist/unknown |
| `dispersal_ability` | O | 迁移/扩散 |
| `functional_group` | H | large_carnivore/large_herbivore/seed_disperser/scavenger/ground_bird/etc. |
| `functional_weight` | D | TW-CVII 功能权重 |
| `trait_source` | H | PanTHERIA/EltonTraits/literature/manual |

### 5.13 `species_site_measurement` 物种-地点指标表

这是文献汇总数据的核心表，也是 PREDICTS Measurement 在本项目中的主要实现。

| 字段 | 等级 | 说明 |
|---|---:|---|
| `measurement_id` | M | 指标编号 |
| `source_id` | M | 来源 |
| `study_id` | M | 研究 |
| `block_id` | H | 区组 |
| `site_id` | M | 地点 |
| `species_id` | M | 标准物种 |
| `taxon_name_entered` | M | 原文名 |
| `measurement` | M | 原始测量值 |
| `diversity_metric_type` | M | abundance/occurrence/richness/diversity/RAI/occupancy/density/activity |
| `diversity_metric` | M | independent_records/photos/RAI/naive_occupancy/etc. |
| `diversity_metric_unit` | H | count/per_100_camera_days/proportion/ind_per_km2 |
| `metric_is_effort_sensitive` | H | yes/no |
| `sampling_effort` | H | 努力量 |
| `sampling_effort_unit` | H | camera_days/trap_nights/stations/days |
| `rescaled_sampling_effort` | D | study 内归一化努力量 |
| `measurement_value_standard` | D | 标准化值 |
| `measurement_unit_standard` | D | 标准单位 |
| `denominator` | H | camera_days/area/stations/occasions |
| `formula_reported` | H | 原文公式 |
| `uncertainty_type` | O | SE/SD/CI |
| `uncertainty_lower` | O | 下限 |
| `uncertainty_upper` | O | 上限 |
| `zero_record_interpretation` | H | true_zero/not_sampled/not_reported/unknown |
| `extraction_page` | M | 页码/表号/附录 |
| `verification_status` | M | verified/unverified |

### 5.14 `diversity_summary` 样点多样性汇总表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `diversity_id` | M | 编号 |
| `study_id` | M | 研究 |
| `site_id` | M | 地点 |
| `taxonomic_scope` | M | mammals/birds/all_camera_trappable |
| `species_richness_observed` | H | 观测物种数 |
| `shannon_index` | O | Shannon |
| `simpson_index` | O | Simpson |
| `total_independent_events` | H | 总独立记录 |
| `total_valid_photos` | H | 总有效照片 |
| `total_camera_days` | H | 总相机工作日 |
| `rarefied_richness` | D | 稀释丰富度 |
| `functional_diversity` | D | 功能多样性 |
| `phylogenetic_diversity` | D | 系统发育多样性 |
| `source_metric_name` | H | 原文指标 |

### 5.15 `historical_expectation` 历史预期表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `expectation_id` | M | 编号 |
| `species_id` | M | 物种 |
| `spatial_unit_id` | M | site/grid/protected_area/ecoregion |
| `spatial_unit_type` | M | site/grid/protected_area/county/ecoregion |
| `historically_expected` | M | yes/no/uncertain |
| `historical_source_id` | H | 历史来源 |
| `historical_source_type` | H | monograph/museum/literature/map/protected_area_survey/expert |
| `historical_record_year` | H | 记录年份 |
| `historical_period` | H | 1950s-1970s/1980s/etc. |
| `historical_locality` | H | 历史地点 |
| `locality_precision` | H | exact/county/protected_area/province/unknown |
| `baseline_scenario` | M | conservative/intermediate/broad |
| `historical_confidence` | M | high/medium/low |
| `native_status` | H | native/introduced/domestic/uncertain |
| `expectation_notes` | O | 备注 |

### 5.16 `survey_adequacy_detection` 调查充分性和探测表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `adequacy_id` | M | 编号 |
| `site_id` | M | 地点 |
| `species_id` | H | 可为物种、类群或 all |
| `taxonomic_scope` | M | mammals/birds/carnivores/ungulates/etc. |
| `camera_days` | H | 相机工作日 |
| `station_count` | H | 相机位点数 |
| `survey_duration_days` | H | 调查天数 |
| `survey_area_km2` | H | 调查面积 |
| `season_coverage` | H | single/multiple/full_year/unknown |
| `habitat_coverage_score` | H | 0-3 |
| `effort_threshold_rule` | M | 文献规则或项目规则 |
| `adequate_for_inventory` | M | yes/no/uncertain |
| `adequate_for_species_group` | H | yes/no/uncertain |
| `detection_probability_estimate` | O | p |
| `detection_model_type` | O | occupancy/hierarchical/community/expert_threshold |
| `detection_covariates_used` | O | effort/season/body_size/habitat/etc. |
| `adequacy_confidence` | M | high/medium/low |
| `notes` | O | 备注 |

### 5.17 `evidence_state` 物种-地点证据状态表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `evidence_id` | M | 编号 |
| `species_id` | M | 物种 |
| `site_id` | M | 地点 |
| `spatial_unit_id` | M | 分析空间单元 |
| `baseline_scenario` | M | conservative/intermediate/broad |
| `historically_expected` | M | yes/no/uncertain |
| `contemporary_detected` | M | yes/no |
| `contemporary_evidence_type` | H | camera_trap/complementary_survey/literature/mixed |
| `latest_detection_year` | H | 最近探测年份 |
| `first_detection_year` | O | 最早当代探测 |
| `independent_records` | H | 独立记录 |
| `rai_per_100_camera_days` | H | 标准化 RAI |
| `occupancy_or_detection_corrected_value` | O | 占域/校正探测值 |
| `survey_adequacy_status` | M | adequate/inadequate/uncertain |
| `evidence_state` | M | confirmed_persistence/silent_range/monitoring_gap/newly_confirmed_occurrence |
| `evidence_confidence` | M | high/medium/low |
| `state_reason` | H | 判定原因 |
| `state_version` | M | 规则版本 |

### 5.18 `reference_baseline_pair` 参考比较表

用于 DiVert/PREDICTS 风格的同研究参考比较，也可用于保护区内外或低干扰-高干扰比较。

| 字段 | 等级 | 说明 |
|---|---:|---|
| `pair_id` | M | 配对编号 |
| `study_id` | M | 研究 |
| `focal_site_id` | M | 处理/被比较地点 |
| `reference_site_id` | H | 参考地点 |
| `reference_type` | M | primary_vegetation/minimally_disturbed/protected_core/historical_baseline/modelled_baseline |
| `pairing_basis` | H | same_study/same_region/same_habitat/matched_covariates |
| `land_use_contrast` | H | cropland_vs_primary/etc. |
| `management_contrast` | O | monoculture_vs_polyculture/logging/etc. |
| `metric_id_focal` | H | focal 指标 |
| `metric_id_reference` | H | reference 指标 |
| `effect_size_type` | D | log_response_ratio/difference/ratio |
| `effect_size_value` | D | 派生值 |
| `zero_handling_rule` | H | half_min_positive/offset/excluded/not_needed |
| `pair_confidence` | H | high/medium/low |

### 5.19 `environmental_covariates` 环境协变量表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `covariate_id` | M | 编号 |
| `site_id` | M | 地点 |
| `grid_id` | H | 网格 |
| `covariate_name` | M | 变量名 |
| `covariate_value` | M | 值 |
| `covariate_unit` | H | 单位 |
| `covariate_source` | H | WorldClim/Human Footprint/land cover/etc. |
| `covariate_year` | H | 年份 |
| `spatial_resolution` | H | 分辨率 |
| `extraction_method` | H | point/buffer/overlay/zonal_stats |

### 5.20 `protected_area_context` 保护地背景表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `pa_context_id` | M | 编号 |
| `site_id` | M | 地点 |
| `protected_area_id` | H | 保护地 ID |
| `protected_area_name` | H | 名称 |
| `pa_type` | H | nature_reserve/national_park/forest_park/wetland_park/etc. |
| `pa_level` | H | national/provincial/local |
| `inside_pa` | M | yes/no/buffer/unknown |
| `distance_to_pa_boundary_m` | O | 到边界距离 |
| `pa_establishment_year` | O | 建立年份 |
| `management_zone` | O | core/buffer/experimental/general |
| `ecological_redline_status` | O | inside/outside/unknown |

### 5.21 `derived_index` TW-CVII 派生指数表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `index_id` | M | 编号 |
| `spatial_unit_id` | M | 空间单元 |
| `spatial_unit_type` | M | site/grid/protected_area/ecoregion |
| `taxonomic_scope` | M | mammals/birds/all_camera_trappable |
| `baseline_scenario` | M | conservative/intermediate/broad |
| `species_intactness` | D | 已确认物种 / 历史预期物种 |
| `detection_corrected_intactness` | D | 探测校正完整性 |
| `threat_weighted_intactness` | D | 威胁加权完整性 |
| `functional_intactness` | D | 功能加权完整性 |
| `abundance_proxy_intactness` | D | RAI/丰度代理完整性 |
| `silent_range_proportion` | D | silent range 比例 |
| `monitoring_gap_proportion` | D | monitoring gap 比例 |
| `newly_confirmed_proportion` | D | 新确认比例 |
| `expected_species_n` | D | 历史预期物种数 |
| `confirmed_species_n` | D | 当代确认物种数 |
| `adequately_surveyed_species_n` | D | 调查充分物种数 |
| `index_rule_version` | M | 指数规则版本 |
| `database_version` | M | 数据库版本 |

### 5.22 `extraction_audit` 抽取审计表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `audit_id` | M | 审计编号 |
| `source_id` | M | 来源 |
| `file_id` | M | PDF/CAJ/附录 |
| `extraction_batch` | M | 批次 |
| `extractor` | M | human/codex/claude/other |
| `extraction_date` | M | 日期 |
| `pages_checked` | M | 页码 |
| `tables_checked` | H | 表号 |
| `figures_checked` | H | 图号 |
| `appendix_checked` | M | yes/no |
| `supplement_checked` | M | yes/no |
| `ocr_required` | H | yes/no |
| `ocr_status` | H | not_needed/pending/done/failed |
| `high_impact_fields_verified` | M | yes/no |
| `unresolved_fields` | H | 字段列表 |
| `confidence` | M | high/medium/low |
| `verifier` | H | 核验人 |
| `verification_date` | H | 日期 |

### 5.23 `issue_log` 问题表

| 字段 | 等级 | 说明 |
|---|---:|---|
| `issue_id` | M | 问题编号 |
| `source_id` | H | 来源 |
| `table_name` | M | 涉及表 |
| `record_id` | H | 涉及记录 |
| `issue_type` | M | missing/full_text/taxonomy/location/effort/metric/appendix/duplicate/license |
| `severity` | M | blocker/high/medium/low |
| `description` | M | 问题描述 |
| `proposed_resolution` | H | 解决方案 |
| `status` | M | open/resolved/deferred/scoped_out |
| `resolved_by` | H | 解决人 |
| `resolved_date` | H | 日期 |

---

## 6. Analysis-ready 视图

实际分析不直接使用所有原始表，而使用冻结视图。

### 6.1 `view_species_site_evidence`

用于 RQ1/RQ2：历史预期和当代证据。

必须包含：

```text
species_id
site_id
spatial_unit_id
baseline_scenario
historically_expected
contemporary_detected
survey_adequacy_status
evidence_state
china_redlist_category
threat_weight
functional_group
body_size_class
independent_records
rai_per_100_camera_days
latest_detection_year
evidence_confidence
```

### 6.2 `view_site_intactness_inputs`

用于计算 TW-CVII。

```text
spatial_unit_id
taxonomic_scope
expected_species_n
confirmed_species_n
silent_range_n
monitoring_gap_n
threat_weight_sum_expected
threat_weight_sum_confirmed
functional_weight_sum_expected
functional_weight_sum_confirmed
camera_days
station_count
survey_area_km2
adequacy_score
```

### 6.3 `view_pa_effectiveness_inputs`

用于保护区效应和匹配分析。

```text
site_id
inside_pa
protected_area_id
pa_type
pa_level
distance_to_pa_boundary_m
predominant_land_use
use_intensity
human_footprint_value
elevation_mean_m
climate_covariates
camera_days
station_count
species_intactness
threat_weighted_intactness
functional_intactness
```

### 6.4 `view_redlist_mismatch_inputs`

用于识别红色名录一致性和监测优先物种。

```text
species_id
china_redlist_category
iucn_category
national_protection_class
expected_site_n
confirmed_site_n
silent_range_site_n
monitoring_gap_site_n
confirmed_persistence_rate
silent_range_rate
data_deficient_flag
trait_group
```

---

## 7. Controlled Vocabularies

### 7.1 `predominant_land_use`

```text
primary_vegetation
secondary_vegetation
cropland
pasture
forestry
agroforestry
urban
mining
water_or_wetland
mixed
unknown
```

### 7.2 `use_intensity`

```text
minimal
light
moderate
intense
unknown
```

### 7.3 `sampling_method`

```text
camera_trap
camera_trap_plus_line_transect
camera_trap_plus_sign_survey
camera_trap_plus_interview
line_transect
point_count
acoustic
literature_compilation
mixed
```

### 7.4 `evidence_state`

```text
confirmed_persistence
silent_range
monitoring_gap
newly_confirmed_occurrence
not_expected_not_detected
uncertain
```

### 7.5 `source_resolution`

```text
raw_media
event_level
station_level
site_summary
study_summary
appendix_summary
text_only
```

---

## 8. Proposal 最低可执行字段

如果要真正执行 TW-CVII proposal，每条 `species_id x spatial_unit_id x baseline_scenario` 至少要能得到：

```text
species_id
spatial_unit_id
historically_expected
historical_confidence
contemporary_detected
latest_detection_year
survey_adequacy_status
evidence_state
china_redlist_category
threat_weight
functional_group
functional_weight
camera_days or adequacy_score
site/protected area/province coordinates
source provenance
```

没有这些字段时，该空间单元不能进入主分析，只能进入：

```text
coverage_gap_analysis
literature_inventory
method_reference
```

---

## 9. 抽取优先级

每篇红外相机文献按以下顺序抽取：

1. `source`、`study`、`site`：先确认来源、研究范围和地点。
2. `deployment`：确认相机数量、位点、监测时段、相机工作日、有效夜数和抽样设计。
3. `species_site_measurement`：物种名录、独立记录、照片/视频、RAI、占域、密度、活动节律。
4. `observation` / `independent_event`：若有原始或事件级数据才抽取。
5. `land_use_management`、`protected_area_context`、`environmental_covariates`：用于 PREDICTS/DiVert/TW-CVII 驱动分析。
6. `historical_expectation`、`conservation_status`、`functional_traits`：构建历史预期和权重。
7. `survey_adequacy_detection`、`evidence_state`、`derived_index`：由规则和脚本生成，人工复核。

附录优先级高于正文摘要。若正文报告“共记录 X 种”，但附录给出完整物种表，以附录为物种表主来源，正文作为交叉校验。

---

## 10. 质量门槛

进入 `v3_analysis_ready` 前必须通过：

1. 所有 included source 有 Zotero item、全文状态、补充材料状态。
2. 所有高影响字段有页码/表号/附录来源。
3. 相机工作日、相机数、监测日期、面积、物种清单和 RAI 不允许只有 AI 未核验值。
4. `source -> study -> site -> measurement` 外键完整。
5. `deployment -> observation` 层有数据时，必须可回溯到 Camtrap DP 风格字段。
6. `historical_expectation` 的基线情景和置信度明确。
7. `silent_range` 不得在调查不充分时生成。
8. `RAI` 不得和真实 abundance/density 混用。
9. 保护区总面积不得替代实际调查面积。
10. DD 物种必须作为不确定性层，而不是简单低权重处理。

---

## 11. 来源与依据

- Camtrap DP data resources: https://camtrap-dp.tdwg.org/data/
- GBIF Best Practices for Managing and Publishing Camera Trap Data: https://docs.gbif.org/camera-trap-guide/en/
- PREDICTS database paper: https://doi.org/10.1002/ece3.2579
- PREDICTS database guide and field structure: https://timnewbold.github.io/PredictsIntroduction.html
- DiVert Zenodo dataset record: https://zenodo.org/records/15347789
- DiVert paper DOI: https://doi.org/10.1111/geb.70261
- Xiao et al. 2022 中国野生动物红外相机监测与研究: https://www.biodiversity-science.net/CN/10.17520/biods.2022451

