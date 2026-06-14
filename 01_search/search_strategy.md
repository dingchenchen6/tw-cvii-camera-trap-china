# 红外相机文献系统检索策略

版本：2026-06-14  
目标：全面检索中国红外相机相关文献、报告、数据集、附录和补充材料，用于 TW-CVII 标准化数据库建设。

## 1. 数据库范围

必须覆盖：

- Web of Science Core Collection
- CNKI / 中国知网
- 万方
- 维普
- Google Scholar
- Biodiversity Science / 生物多样性
- 兽类学报
- 浙江林业科技、四川动物、动物学杂志、生态学报、应用生态学报、生物多样性等中文期刊网站
- 保护区、国家公园、林草局、生态环境部、科研院所、高校报告
- 参考文献追踪和被引追踪
- 数据仓储：GBIF、Zenodo、Figshare、Dryad、DataOne、期刊 supplementary data

## 2. 检索轮次

| 轮次 | 目的 | 中文核心词 | 英文核心词 |
|---|---|---|---|
| R1 | 广义召回 | 红外相机、自动相机、相机陷阱、红外触发相机 | camera trap, camera-trap, camera trapping, infrared camera, automatic camera |
| R2 | 物种编目 | 物种多样性、物种组成、物种编目、鸟兽资源、兽类资源、鸟类资源 | species inventory, species richness, mammal diversity, bird diversity, vertebrate diversity |
| R3 | 丰度/RAI | 相对多度、相对多度指数、多度、丰度、独立有效照片 | relative abundance index, RAI, abundance, independent events |
| R4 | 采样努力量 | 相机工作日、有效相机日、监测时长、调查时间、相机数量、位点数、样区、网格 | camera days, trap nights, sampling effort, camera stations, deployment, grid |
| R5 | 地点/保护地 | 自然保护区、国家公园、保护地、森林公园、湿地、山系、省名 | nature reserve, national park, protected area, reserve, China |
| R6 | 干扰 | 人为干扰、放牧、家畜、狗、猫、道路、盗猎、旅游 | human disturbance, livestock, cattle, goat, dog, road, poaching, tourism |
| R7 | 方法/模型 | 占域、密度、活动节律、时空分布、MaxEnt、occupancy | occupancy, density, activity pattern, temporal activity, detection probability |
| R8 | 追踪 | 同一保护区、同一作者、参考文献、被引文献、补充材料 | cited references, citing articles, same site, same author, supplementary |

## 3. 中文检索式示例

```text
("红外相机" OR "自动相机" OR "相机陷阱" OR "红外触发相机")
AND ("野生动物" OR "兽类" OR "鸟兽" OR "鸟类" OR "脊椎动物")
```

```text
("红外相机" OR "自动相机" OR "相机陷阱")
AND ("物种多样性" OR "物种组成" OR "物种编目" OR "鸟兽资源" OR "兽类资源")
```

```text
("红外相机" OR "自动相机")
AND ("相对多度" OR "相对多度指数" OR "多度" OR "丰度" OR "独立有效照片" OR "RAI")
```

```text
("红外相机" OR "自动相机")
AND ("相机工作日" OR "有效相机日" OR "监测时长" OR "调查时间" OR "相机数量" OR "布设" OR "网格")
```

```text
("红外相机" OR "自动相机")
AND ("自然保护区" OR "国家公园" OR "保护地" OR "森林公园")
AND ("兽类" OR "鸟类" OR "鸟兽")
```

```text
("红外相机" OR "自动相机")
AND ("人为干扰" OR "放牧" OR "家畜" OR "狗" OR "道路" OR "盗猎" OR "旅游")
```

## 4. English Query Examples

```text
TS=("camera trap*" OR "camera-trap*" OR "camera trapping" OR "infrared camera*" OR "automatic camera*")
AND TS=(China OR Chinese OR Tibet OR Xinjiang OR Yunnan OR Sichuan OR Qinghai OR Zhejiang)
```

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("species inventory" OR "species richness" OR biodiversity OR "mammal diversity" OR "bird diversity" OR vertebrate*)
AND TS=(China OR "nature reserve" OR "national park" OR "protected area")
```

```text
TS=("camera trap*" OR "camera-trap*" OR "infrared camera*")
AND TS=("relative abundance index" OR RAI OR "camera day*" OR "trap night*" OR "sampling effort" OR abundance OR density OR occupancy)
AND TS=(China OR Chinese)
```

```text
TS=("camera trap*" OR "camera-trap*")
AND TS=("human disturbance" OR livestock OR cattle OR goat OR dog OR road OR poaching OR tourism)
AND TS=(China OR "protected area" OR "nature reserve")
```

## 5. 导出规范

每次检索必须写入 `01_search/search_log.csv`：

- `search_id`
- `date`
- `database_or_source`
- `platform_access`
- `query_round`
- `query`
- `query_language`
- `result_count_observed`
- `records_exported`
- `export_file`
- `deduplicated_count`
- `status`
- `notes`

导出文件登记到 `01_search/database_export_manifest.csv`。

推荐导出格式：

- Web of Science: RIS 或 Tab-delimited + full record and cited references
- CNKI: EndNote/RIS 或 Refworks/NoteExpress 兼容格式；同时保存检索截图或 query snapshot
- 万方/维普：RIS/EndNote/CSV，无法批量时保存页面导出记录
- Google Scholar：逐条 BibTeX，需记录搜索页码和日期
- 期刊网站：Zotero Connector 保存 landing page；PDF 和 supplementary 单独登记

## 6. 下载规范

下载文件登记到：

- `03_full_text/pdf_manifest.csv`
- `03_full_text/supplementary_manifest.csv`
- `03_full_text/no_full_text_reason.csv`

命名规则：

```text
SRC000001_author_site_year.pdf
SRC000001_appendix_table_S1_species_inventory.xlsx
SRC000001_text_extract.txt
```

下载必须记录：

- URL 或数据库来源
- 下载日期
- 文件类型
- SHA256
- OCR 状态
- 文本提取路径
- 版权/访问说明

## 7. 追踪检索

每篇 included 文献必须完成：

1. 检查参考文献中同一保护区、同一作者、同一物种编目相关文献。
2. 检查被引文献。
3. 搜索同一保护区名 + 红外相机。
4. 搜索同一 DOI、题名、作者的 supplementary。
5. 搜索同一保护区历史兽类/鸟类记录，用于 `historical_expectation`。
