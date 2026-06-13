# 清洗与标准化规则 (Cleaning Rules)

> 详细规则见 `../camera_trap_literature_to_database_workflow.md` 第 12 节（单一真源）。本文件记录**本项目实际采用的具体取值/阈值**，供清洗脚本 (`09_analysis/scripts/`) 引用。

## 1. 分类学
- 接受名来源优先级：中国生物物种名录 > Catalogue of Life > GBIF > 人工。
- 不能确认到 species 时保留 genus/family，不强行降级。
- 家畜、犬、人类记录不进野生动物物种丰富度，进 `disturbance` 表。
- 同物异名全部进 `taxonomy_crosswalk.csv`。

## 2. 日期
- 统一 ISO `YYYY-MM-DD`；只给月份时 `date_precision=month`，日期填月初并标注。
- 相机工作日优先用文献原值；派生公式 `camera_days = camera_count*active_days − malfunction_days`，派生值标 `effort_source=derived`。

## 3. 面积
- 全部标准化 km²；ha→km²: `÷100`。
- 分开三个字段，不得混用：`protected_area_total_km2` / `survey_area_km2` / `effective_sampling_area_km2`。

## 4. RAI
- 标准化：`RAI = independent_records / camera_days * 100`。
- 必须记录分子类型：`rai_numerator = independent_records` 或 `valid_photos`。
- 不同独立记录阈值（30/60 min）的 RAI 不可直接混合。

## 5. 坐标
- 统一 WGS84。只给保护区名时用 centroid，置 `coordinate_precision=centroid` 并保留不确定性半径。
- 敏感物种坐标按 `00_admin/source_use_policy.md` 泛化后再入公开库。

## 6. 缺失码
```text
NR = 文献未报告
NA = 不适用
UNK = 无法判断
PENDING = 待核验
EXTRACTED_UNVERIFIED = 已抽取未核验
RESTRICTED = 受数据权限限制
```

## 7. 调查充分性阈值（区分 silent range / monitoring gap，源自 proposal §6.2）
| 类群 | 最低相机工作日 | 最低相机位点数 | 其他 |
|---|---:|---:|---|
| 中型食肉动物 | ≥1000 | ≥15 | 跨季节 |
| 大型食肉动物 | ≥5000 | ≥30 | 跨≥12个月 |
| 中型有蹄类、地栖鸟类 | ≥600–800 | ≥10–12 | — |
未达阈值的物种-地点不得记为 silent_range，只能记 monitoring_gap 或 PENDING。

## 8. 红色名录权重
几何级数：LC=1, NT=2, VU=4, EN=8, CR=16。DD 物种不进主分母，单列知识赤字层。
