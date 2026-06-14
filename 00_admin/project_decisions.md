# 项目决策记录 (Project Decisions)

记录影响数据库结构、分析方案或工作流的关键决策。每条决策注明日期、背景、决定、影响范围。

## 决策模板

```text
决策编号: DEC000001
日期: YYYY-MM-DD
背景:
决定:
影响范围:
替代方案:
决定人:
状态: proposed / accepted / superseded
```

---

<!-- 在此追加决策，最新放最上面 -->

## DEC000001 — 数据库发布版本采用 4 版方案
- 日期: 2026-06-13
- 决定: 统一为 `v0_raw_ingest / v1_cleaned_core / v2_analysis_ready / v3_manuscript_freeze`，与 TW-CVII proposal 一致；废弃早期 5 版写法。
- 影响范围: `camera_trap_literature_to_database_workflow.md` §13、`08_database/`、各 verified 表的 `verification_status` 取值。

## DEC000000 — 建立工作流骨架
- 日期: 2026-06-13
- 决定: 按 workflow.md §1 建立 12 目录骨架与 CSV/MD 模板，作为执行完整工作流的起点。
