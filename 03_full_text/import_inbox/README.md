# import_inbox — Zotero 文献投放区

把你在 CNKI/WoS/Zotero 检索下载的文献拖到这里，跑一个脚本就自动接入数据库管线。

## 怎么用（3 步）

### 第 1 步：从 Zotero 导出题录
在 Zotero 里选中文献 → 右键 → **导出条目** → 格式选 **RIS**（或 Better BibTeX）→ 保存到这里。

### 第 2 步：放 PDF
把对应的 PDF 也放进来，**文件名与题录文件同名**（去掉扩展名）：
```
import_inbox/
  li2024foping.ris      ← Zotero 导出的题录
  li2024foping.pdf      ← 同名 PDF
```
> 只有 PDF 也行（脚本会用文件名做占位题录，你后续手补）。

### 第 3 步：运行导入脚本
```bash
cd <项目根>
Rscript 09_analysis/scripts/04_import_inbox.R
```

脚本会自动：
- 解析题录（标题/作者/年/期刊/DOI/URL/语言）
- 分配 `SRC000xxx` ID，注册到 `02_zotero/literature_registry.csv`
- 提取 PDF 文本到 `05_extraction_raw/text/`
- 生成已填好题录的 source 行到 `06_extraction_verified/seed_sources.csv`
- 把 PDF 归档到 `03_full_text/`

之后你（或我）只需补 study/site/species 的抽取内容，重跑 `03_ingest.R` 即可入库。

## 命名约定
- 推荐 citekey 命名：`作者年关键词`（如 `li2024foping`、`wang2023tibetan`）
- 多篇文献放多个 `.ris + .pdf` 对，脚本会全部处理

## 关于 Zotero Connector（浏览器插件）
装了 Zotero Connector 后，在 CNKI/WoS 文献详情页点一下浏览器工具栏的 Zotero 图标，
就能自动抓题录 + PDF 进 Zotero 库，再批量导出 RIS 放这里，全程不用手动填元数据。
