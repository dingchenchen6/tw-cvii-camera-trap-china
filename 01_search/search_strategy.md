# 文献检索策略 (Search Strategy)

> 本文件是检索的执行计划。完整关键词矩阵、检索式、检索轮次定义见 `../camera_trap_literature_to_database_workflow.md` 第 3–5 节（单一真源）；本文件记录本批次执行状态，并附可直接复制到数据库平台的查询库。

## 检索轮次（R1–R8）

| 轮次 | 目的 | 中文核心词 | 英文核心词 | 状态 | 负责人 | 备注 |
|---|---|---|---|---|---|---|
| R1 广泛召回 | 最大化红外相机相关文献 | 红外相机、自动相机、相机陷阱、红外触发相机 | camera trap, camera-trap, camera trapping, infrared camera, automatic camera | ⬜ 未开始 | | |
| R2 物种编目 | 物种清单、鸟兽资源、兽类多样性 | 物种多样性、物种组成、物种编目、鸟兽资源 | species inventory, species richness, mammal diversity, bird diversity | ⬜ 未开始 | | |
| R3 丰度/多度 | RAI、多度、相对丰度、活动强度 | 相对多度、相对多度指数、多度、丰度、独立有效照片 | relative abundance index, RAI, abundance, independent events | ⬜ 未开始 | | |
| R4 方法与努力量 | 相机数量、相机工作日、监测时长 | 相机工作日、有效相机日、监测时长、相机数量、位点数、网格 | camera days, trap nights, sampling effort, camera stations, deployment, grid | ⬜ 未开始 | | |
| R5 空间对象 | 保护区、国家公园、山系、县域 | 自然保护区、国家公园、保护地、森林公园、省名 | nature reserve, national park, protected area, reserve, China | ⬜ 未开始 | | |
| R6 目标类群/干扰 | 兽类、地栖鸟类、食肉动物、家畜干扰 | 人为干扰、放牧、家畜、狗、猫、道路、盗猎 | human disturbance, livestock, dog, road, poaching, tourism | ⬜ 未开始 | | |
| R7 方法模型 | 占域、密度、活动节律、探测概率 | 占域、密度、活动节律、时空分布、探测概率 | occupancy, density, activity pattern, detection probability | ⬜ 未开始 | | |
| R8 追踪补漏 | 被引、参考文献、同作者、同区域 | 同一保护区、同一作者、参考文献、被引文献、补充材料 | cited references, citing articles, same site, same author, supplementary | ⬜ 未开始 | | |

## 执行记录

每完成一轮检索，向 `search_log.csv` 追加一行，并把导出文件放 `query_snapshots/`。
命名规则：`YYYYMMDD_database_query_round.csv`（如 `20260614_cnki_R1.csv`）。

## 中文检索式示例

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

## English Query Examples

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

## 导出规范

每次检索必须写入 `01_search/search_log.csv`；数据库导出登记到 `01_search/database_export_manifest.csv`。

推荐导出格式：

- Web of Science: RIS 或 Tab-delimited + full record and cited references
- CNKI: EndNote/RIS 或 Refworks/NoteExpress 兼容格式；同时保存检索截图或 query snapshot
- 万方/维普：RIS/EndNote/CSV，无法批量时保存页面导出记录
- Google Scholar：逐条 BibTeX，需记录搜索页码和日期
- 期刊网站：Zotero Connector 保存 landing page；PDF 和 supplementary 单独登记

## 完成定义（Gate 1 通过条件）

- [ ] R1–R8 全部完成
- [ ] Web of Science、CNKI、万方、维普、Google Scholar 和核心期刊站点均有检索记录
- [ ] 每个数据库有检索式和结果数（见 `search_log.csv`）
- [ ] 核心综述已做前向/后向追踪（见 `citation_chasing_log.csv`）
- [ ] 中文和英文关键词都用过
- [ ] included 文献的 DOI/URL、Zotero key、PDF/full-text status、supplement status 均已登记
