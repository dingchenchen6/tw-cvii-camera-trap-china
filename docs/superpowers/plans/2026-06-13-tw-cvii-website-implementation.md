# TW-CVII Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish a polished bilingual GitHub Pages website for the TW-CVII camera-trap research project.

**Architecture:** The first release is a static single-page application. `index.html` provides semantic containers, `assets/data/content.js` stores bilingual mode content, `assets/js/site.js` handles language and mode switching, and `assets/css/styles.css` handles the professional ecological research portal design.

**Tech Stack:** Static HTML, CSS, vanilla JavaScript, GitHub Pages, GitHub CLI.

---

## File Structure

- Create: `/Users/dingchenchen/Documents/红外相机研究/index.html`
  - Semantic page shell, navigation, main content mount, footer, script/style links.
- Create: `/Users/dingchenchen/Documents/红外相机研究/assets/css/styles.css`
  - Responsive visual system, mode tabs, cards, diagrams, matrix, workflow, schema, analysis layouts.
- Create: `/Users/dingchenchen/Documents/红外相机研究/assets/js/site.js`
  - Render functions, language toggle, mode tab switching, hash navigation, localStorage.
- Create: `/Users/dingchenchen/Documents/红外相机研究/assets/data/content.js`
  - Bilingual text and structured content for Research, Workflow, Database, Analysis.
- Create: `/Users/dingchenchen/Documents/红外相机研究/.nojekyll`
  - Disable Jekyll processing for a custom static site.
- Create: `/Users/dingchenchen/Documents/红外相机研究/README.md`
  - Project overview, local preview, GitHub Pages URL, privacy/data boundaries.
- Modify: `/Users/dingchenchen/Documents/红外相机研究/.gitignore`
  - Already excludes `.superpowers/`, `node_modules/`, `dist/`, `.DS_Store`.

## Task 1: Static Page Shell

**Files:**
- Create: `index.html`
- Create: `.nojekyll`

- [ ] **Step 1: Create semantic HTML shell**

Create `index.html` with:

```html
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="TW-CVII China: a bilingual research portal for threat-weighted camera-trap vertebrate intactness, literature workflow, standardized database schema, and analysis framework.">
  <title>TW-CVII China | Camera-trap Vertebrate Intactness</title>
  <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
  <a class="skip-link" href="#main">Skip to content</a>
  <header class="site-header">
    <nav class="nav" aria-label="Primary navigation">
      <a class="brand" href="#research" aria-label="TW-CVII China home">
        <span class="brand-mark">TW</span>
        <span>
          <strong>TW-CVII China</strong>
          <small data-i18n="brandSub">红外相机脊椎动物完整性</small>
        </span>
      </a>
      <div class="mode-tabs" role="tablist" aria-label="Website sections">
        <button class="mode-tab" data-mode="research" type="button">Research</button>
        <button class="mode-tab" data-mode="workflow" type="button">Workflow</button>
        <button class="mode-tab" data-mode="database" type="button">Database</button>
        <button class="mode-tab" data-mode="analysis" type="button">Analysis</button>
      </div>
      <div class="nav-actions">
        <button id="languageToggle" class="language-toggle" type="button" aria-label="Switch language">中文 | EN</button>
        <a class="github-link" href="https://github.com/dingchenchen6/tw-cvii-camera-trap-china" rel="noreferrer">GitHub</a>
      </div>
    </nav>
  </header>
  <main id="main" class="site-main" tabindex="-1">
    <section id="app" aria-live="polite"></section>
  </main>
  <footer class="site-footer">
    <p id="footerText"></p>
  </footer>
  <script src="assets/data/content.js"></script>
  <script src="assets/js/site.js"></script>
</body>
</html>
```

- [ ] **Step 2: Add `.nojekyll`**

Run: `touch .nojekyll`

- [ ] **Step 3: Verify shell loads**

Run: `python3 -m http.server 8080`

Expected: `http://localhost:8080/` serves `index.html`.

## Task 2: Bilingual Content Data

**Files:**
- Create: `assets/data/content.js`

- [ ] **Step 1: Create content object**

Define `window.TWCVII_CONTENT` with:

```js
window.TWCVII_CONTENT = {
  zh: {
    brandSub: "红外相机脊椎动物完整性",
    footer: "TW-CVII China 是一个公开学术项目站。原始全文、Zotero 本地数据和敏感坐标不在网站发布。",
    modes: {
      research: { label: "Research", eyebrow: "研究框架", title: "威胁加权红外相机脊椎动物完整性指数", subtitle: "整合历史分布、当代红外相机证据、调查充分性、红色名录和功能性状，评估中国陆生脊椎动物群落是否仍然保持可探测、可解释的生态完整性。" },
      workflow: { label: "Workflow", eyebrow: "工作流", title: "从文献检索到标准化数据库", subtitle: "多库检索、Zotero 知识库、OneFind 本地检索、AI 候选抽取、人工核验、清洗标准化、数据库冻结和论文写作审计。" },
      database: { label: "Database", eyebrow: "数据库", title: "PREDICTS / DiVert / Camtrap DP 对齐的红外相机数据库", subtitle: "以 Source-Study-Block-Site-Measurement 为生态层级，以 deployment-media-observation 为红外相机技术骨架，并加入 TW-CVII 的历史预期和证据状态表。" },
      analysis: { label: "Analysis", eyebrow: "统计分析", title: "把数据库转化为 TW-CVII 研究输出", subtitle: "支持 silent range、monitoring gap、威胁加权完整性、功能完整性、保护区比较和红色名录一致性分析。" }
    }
  },
  en: {
    brandSub: "Camera-trap vertebrate intactness",
    footer: "TW-CVII China is a public academic project website. Raw full texts, local Zotero data, and sensitive coordinates are not published here.",
    modes: {
      research: { label: "Research", eyebrow: "Research framework", title: "Threat-weighted Camera-trap Vertebrate Intactness Index", subtitle: "Integrating historical distributions, contemporary camera-trap evidence, survey adequacy, Red List status, and functional traits to evaluate evidence-based vertebrate intactness in China." },
      workflow: { label: "Workflow", eyebrow: "Workflow", title: "From literature search to standardized database", subtitle: "Multi-database searches, Zotero knowledge base, OneFind retrieval, AI-assisted candidate extraction, human verification, cleaning, database release, and manuscript audit." },
      database: { label: "Database", eyebrow: "Database", title: "A PREDICTS / DiVert / Camtrap DP-aligned camera-trap database", subtitle: "Combining Source-Study-Block-Site-Measurement ecological structure with deployment-media-observation camera-trap structure and TW-CVII evidence-state tables." },
      analysis: { label: "Analysis", eyebrow: "Statistical analysis", title: "Turning the database into TW-CVII research outputs", subtitle: "Supporting silent-range, monitoring-gap, threat-weighted intactness, functional intactness, protected-area comparison, and Red List mismatch analyses." }
    }
  }
};
```

- [ ] **Step 2: Add arrays for cards, matrices, workflow, schema, analysis**

Add structured arrays inside each mode for metric cards, diagram items, and section cards. Reuse the same keys in Chinese and English.

- [ ] **Step 3: Verify JavaScript syntax**

Run: `node --check assets/data/content.js`

Expected: no syntax errors.

## Task 3: Rendering and Interaction

**Files:**
- Create: `assets/js/site.js`

- [ ] **Step 1: Implement state and helpers**

Create state:

```js
const state = {
  language: localStorage.getItem("twcvii-language") || "zh",
  mode: getInitialMode()
};
```

Implement `getInitialMode`, `setLanguage`, `setMode`, `render`, and escaping helpers.

- [ ] **Step 2: Render mode content**

Render:

- hero summary
- key metric cards
- mode-specific primary diagram
- lower detail sections
- sources and data-boundary notes

- [ ] **Step 3: Wire controls**

Attach listeners to:

- `#languageToggle`
- `.mode-tab`
- `window.hashchange`

Expected behavior:

- Language toggles Chinese/English in place.
- Mode tabs update visible content.
- Hash updates to `#research`, `#workflow`, `#database`, or `#analysis`.
- Active tab has `aria-selected="true"`.

- [ ] **Step 4: Verify JavaScript syntax**

Run: `node --check assets/js/site.js`

Expected: no syntax errors.

## Task 4: Professional Visual Design

**Files:**
- Create: `assets/css/styles.css`

- [ ] **Step 1: Define visual tokens**

Define CSS variables for:

- background
- surface
- forest
- moss
- teal
- amber
- rust
- slate
- muted text
- borders
- shadows

- [ ] **Step 2: Style global layout**

Style body, sticky header, navigation, brand, mode tabs, language toggle, GitHub link, main area, footer.

- [ ] **Step 3: Style research portal sections**

Style:

- hero grid
- stat cards
- evidence-state matrix
- workflow timeline
- schema cards
- analysis cards
- responsive mobile layout

- [ ] **Step 4: Check CSS syntax enough for browser use**

Run: `python3 -m http.server 8080`

Expected: browser displays polished layout with no overlapping text at desktop and mobile widths.

## Task 5: Documentation, GitHub, and Publishing

**Files:**
- Create: `README.md`
- Modify: tracked files from Tasks 1-4

- [ ] **Step 1: Create README**

Include:

- project title
- site purpose
- local preview command
- module list
- data boundary statement
- expected GitHub Pages URL

- [ ] **Step 2: Run local checks**

Run:

```bash
node --check assets/data/content.js
node --check assets/js/site.js
python3 -m http.server 8080
```

Expected:

- JS syntax checks pass.
- Local site opens at `http://localhost:8080/`.

- [ ] **Step 3: Create GitHub repo if missing**

Run:

```bash
gh repo view dingchenchen6/tw-cvii-camera-trap-china
```

If missing, run:

```bash
gh repo create dingchenchen6/tw-cvii-camera-trap-china --public --source=. --remote=origin --description "Bilingual research portal for the TW-CVII China camera-trap vertebrate intactness project"
```

- [ ] **Step 4: Commit website implementation**

Run:

```bash
git add index.html assets .nojekyll README.md docs/superpowers/plans/2026-06-13-tw-cvii-website-implementation.md
git commit -m "Build bilingual TW-CVII research website"
```

- [ ] **Step 5: Push main**

Run:

```bash
git push -u origin main
```

- [ ] **Step 6: Enable GitHub Pages**

Try:

```bash
gh api repos/dingchenchen6/tw-cvii-camera-trap-china/pages \
  -X POST \
  -f source.branch=main \
  -f source.path=/
```

If GitHub reports Pages already exists, update or document the manual setting:

```text
Repository Settings -> Pages -> Build and deployment -> Deploy from branch -> main -> /root
```

- [ ] **Step 7: Verify published site**

Visit:

```text
https://dingchenchen6.github.io/tw-cvii-camera-trap-china/
```

Expected:

- Website loads after GitHub Pages deployment finishes.
- Language toggle works.
- Four mode tabs work.
- No sensitive raw data is exposed.

## Self-Review

Spec coverage:

- Bilingual behavior: Task 2 and Task 3.
- Mode tabs: Task 1 and Task 3.
- Professional visual system: Task 4.
- Proposal/workflow/database/analysis content: Task 2.
- GitHub Pages publishing: Task 5.
- Sensitive-data boundary: Task 2, Task 5 README, final verification.

Incomplete-instruction scan:

- No `TODO`, `TBD`, or unresolved filler instructions remain.

Type consistency:

- `language`, `mode`, `modes`, `research`, `workflow`, `database`, and `analysis` are used consistently.
