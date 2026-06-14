# 排除原因受控词表 (Exclusion Reasons Controlled Vocabulary)

题录/全文筛选时，`04_screening/screening_decisions.csv` 的 `exclusion_reason` 字段必须取下列受控词之一，保证可统计、可复核。

| 代码 | 含义 |
|---|---|
| `not_camera_trap` | 非地面红外相机/相机陷阱（如热红外遥感、普通红外摄影） |
| `outside_china` | 研究地点不在中国，且无方法标准参考价值 |
| `product_or_ad` | 设备广告/产品评测，无野生动物监测数据 |
| `no_usable_data` | 无物种名录/独立记录/RAI/努力量等可用变量 |
| `duplicate` | 与已纳入文献重复（去重组 id 记入 source.duplicate_group_id） |
| `full_text_unavailable` | 全文长期不可得且题录不足以判断变量 |
| `suspected_plagiarism` | 疑似重复发表/抄袭 |
| `method_reference_only` | 降级为方法/标准参考，不进主抽取（仍留 Zotero） |
| `other` | 其他（必须在 notes 字段写明） |

## 筛选状态码（screening_decisions.csv 的 decision 字段）

```text
title_abstract_include
title_abstract_exclude
fulltext_include
fulltext_exclude
method_reference_only
awaiting_full_text
duplicate
```
