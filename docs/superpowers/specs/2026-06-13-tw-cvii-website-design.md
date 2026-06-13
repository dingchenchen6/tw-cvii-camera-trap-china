# TW-CVII Research Website Design

Date: 2026-06-13  
Project: Threat-weighted Camera-trap Vertebrate Intactness Index for China  
Repository owner target: `dingchenchen6` on GitHub  
Hosting target: GitHub Pages

## 1. Purpose

Build a polished, professional, bilingual project website for the TW-CVII camera-trap research project. The site should communicate the proposal, the research workflow, the standardized camera-trap database, and the statistical analysis framework clearly enough for advisors, collaborators, reviewers, and future users of the database.

The site is public-facing. It will not publish raw PDFs, copyrighted full texts, restricted datasets, exact sensitive wildlife locations, or private Zotero/OneFind data. It can publish project descriptions, reproducible workflow diagrams, database schema documentation, controlled vocabularies, non-sensitive examples, and analysis plans.

## 2. Core Design Decision

Use one unified static website with two interactive switching layers:

1. Language switch: `中文 / English`.
2. Mode tabs: `Research / Workflow / Database / Analysis`.

The user selected the dashboard-like mode-tab design. The site should keep one coherent visual identity while changing the information density and content emphasis for each mode.

## 3. Content Architecture

### 3.1 Global Layout

- Sticky top navigation.
- Left brand area: `TW-CVII China`.
- Main mode tabs: `Research`, `Workflow`, `Database`, `Analysis`.
- Right controls: language toggle `中文 | English`, GitHub link, optional download buttons.
- First screen shows the selected mode immediately; no marketing-only landing page.
- Each mode has a concise summary, key visual module, and deep sections below.

### 3.2 Research Mode

Purpose: Present the proposal as a rigorous research program.

Content:

- Project title and short title.
- Abstract-style summary.
- Overall aim and objectives.
- Research questions and hypotheses.
- Four evidence states:
  - confirmed persistence
  - silent range
  - monitoring gap
  - newly confirmed occurrence
- TW-CVII concept:
  - species intactness
  - detection-corrected intactness
  - threat-weighted intactness
  - functional intactness
  - abundance-proxy intactness
- Study system: camera-trappable terrestrial vertebrates in China.

Visual treatment:

- Strong academic hero with concise index cards.
- Evidence-state matrix.
- Conceptual framework diagram.

### 3.3 Workflow Mode

Purpose: Show the end-to-end research production workflow.

Content:

- Literature search strategy:
  - Web of Science
  - CNKI / 知网
  - Wanfang
  - VIP
  - Google Scholar
  - Biodiversity Science
  - citation chasing
- Zotero knowledge base structure.
- OneFind local knowledge retrieval.
- Full-text and appendix handling.
- AI-assisted extraction with human verification.
- Cleaning, standardization, database release, analysis, manuscript writing.
- Six QA gates:
  - search completeness
  - Zotero integrity
  - full text and appendix
  - extraction
  - standardization
  - analysis-ready release

Visual treatment:

- Horizontal pipeline on desktop.
- Vertical stepper on mobile.
- QA gates as compact status cards.

### 3.4 Database Mode

Purpose: Present the standardized database as a serious research infrastructure.

Content:

- PREDICTS-style structure: `Source -> Study -> Block -> Site -> Measurement`.
- DiVert-style land-use and management fields.
- Camtrap DP-style structure: `deployment -> media -> observation -> independent_event`.
- TW-CVII analytical tables:
  - `historical_expectation`
  - `survey_adequacy_detection`
  - `evidence_state`
  - `conservation_status`
  - `functional_traits`
  - `derived_index`
- Field tiers:
  - mandatory
  - high priority
  - optional
  - derived
- Missing codes:
  - `NR`
  - `NA`
  - `UNK`
  - `PENDING`
  - `EXTRACTED_UNVERIFIED`

Visual treatment:

- Schema map.
- Table cards grouped by layer:
  - Evidence source
  - Study and site
  - Camera-trap data
  - Species and traits
  - TW-CVII analysis
- Search/filter UI for table names and fields if implementation time allows.

### 3.5 Analysis Mode

Purpose: Show how the database executes the proposal.

Content:

- Analysis-ready views:
  - `view_species_site_evidence`
  - `view_site_intactness_inputs`
  - `view_pa_effectiveness_inputs`
  - `view_redlist_mismatch_inputs`
- Main outputs:
  - literature coverage map
  - species-site evidence matrix
  - silent range and monitoring gap maps
  - threat-weighted intactness profiles
  - protected-area effectiveness analysis
  - Red List mismatch and monitoring priority species
- Statistical framework:
  - hierarchical models
  - occupancy/detection correction where possible
  - matched protected-area comparisons
  - sensitivity analysis across baseline scenarios

Visual treatment:

- Analytical dashboard style.
- Draft charts should be clearly marked as framework examples, not real results.
- Do not imply data have been analyzed before the database is populated.

## 4. Bilingual Behavior

The website will ship both Chinese and English content in the front-end code. The language toggle switches visible text in place without reloading the page.

Default language: Chinese.

Rules:

- Every main heading, card label, button, section summary, and diagram label should have Chinese and English versions.
- Technical table names remain in English code style, with Chinese explanations nearby.
- Language preference can be stored in `localStorage`.
- No machine-translation filler text.

## 5. Mode Tab Behavior

The `Research / Workflow / Database / Analysis` tabs switch the main page content.

Rules:

- The selected tab updates the hero, key cards, primary diagram, and lower sections.
- The site stays on one page for smooth GitHub Pages hosting and easy sharing.
- URL hash should update, for example `#research`, `#workflow`, `#database`, `#analysis`, so links can open a specific module.
- On mobile, tabs become horizontally scrollable segmented controls.

## 6. Visual System

Recommended direction: professional ecological research portal.

Palette:

- Deep forest green for identity and navigation.
- Off-white or light neutral background.
- Slate/charcoal text for academic seriousness.
- Muted teal, moss, amber, and rust accents for state labels and charts.
- Avoid one-note green-only styling; use multiple restrained accent families.

Typography:

- Use a clean sans-serif stack for interface text.
- Use strong, compact headings.
- Avoid oversized marketing hero typography inside dense dashboard sections.

Components:

- Sticky navigation.
- Segmented mode controls.
- Language toggle.
- Metric cards.
- Evidence-state matrix.
- Workflow timeline.
- Schema table cards.
- Analysis cards.
- Download/source links.
- Footer with citation/source notes.

Visual assets:

- Use generated or CSS-based abstract camera-trap landscape treatment only if needed.
- Do not use dark, blurred, stock-like wildlife imagery as the primary proof of the project.
- The main content should communicate actual research structure rather than generic nature imagery.

## 7. Technical Architecture

Use a static front-end that works well on GitHub Pages.

Recommended implementation:

- `index.html`
- `assets/css/styles.css`
- `assets/js/site.js`
- `assets/data/content.js` or inline structured content object
- `.nojekyll`
- `README.md`

No backend is required. GitHub Pages supports static HTML, CSS, and JavaScript directly, so the first version should not require a complex build pipeline.

If a later version needs charts, the site can add lightweight client-side SVG or a charting library. The first implementation should prioritize reliability and visual polish.

## 8. GitHub and Publishing Plan

The local project is already a git repository but has no commits yet. GitHub CLI is authenticated as `dingchenchen6`.

Target repository name:

```text
tw-cvii-camera-trap-china
```

Recommended visibility:

```text
public
```

Reason: GitHub Pages is intended as a public academic project site. Sensitive raw data should be excluded from the repository instead of relying on repository privacy.

Publishing strategy:

- Use GitHub Pages from the `main` branch root.
- Include `.nojekyll` to prevent Jekyll processing of a custom static site.
- If later adding a build system, switch to GitHub Actions Pages deployment.

Expected public URL after publishing:

```text
https://dingchenchen6.github.io/tw-cvii-camera-trap-china/
```

## 9. Content Sources

The first website version should draw from these local files:

- `TW-CVII_China_Proposal_20260613_workflow_optimized.docx`
- `camera_trap_literature_to_database_workflow.md`
- `camera_trap_database_schema_predicts_divert_twcvii.md`
- `camera-trap-database-workflow` Codex skill references

External reference links can appear in the footer or sources section:

- GitHub Pages documentation
- Camtrap DP
- GBIF camera-trap guide
- PREDICTS database paper and field guide
- DiVert paper and Zenodo record
- Xiao et al. 2022 Biodiversity Science camera-trap review

## 10. Accessibility and Responsiveness

Requirements:

- Responsive layout for desktop, tablet, and mobile.
- Buttons and tabs must have visible active states.
- Text must not overflow buttons or cards.
- Color contrast must be sufficient for academic presentation.
- Keyboard focus states for tabs and language toggle.
- The site should remain usable without external fonts.

## 11. Data and Ethics Boundaries

Do not publish:

- Raw copyrighted PDFs or CAJ files.
- Zotero local database files.
- Exact coordinates for sensitive species or unpublished camera stations.
- Private notes, WeChat attachments, or personal data.
- Restricted datasets without permission.

Allowed:

- Research concept.
- Workflow.
- Database schema.
- Controlled vocabularies.
- Non-sensitive example rows.
- Aggregated future outputs.
- Links and citations.

## 12. Implementation Acceptance Criteria

The website is ready when:

1. It runs locally with no broken layout on desktop and mobile.
2. Chinese and English language switching works across all major sections.
3. `Research / Workflow / Database / Analysis` tabs switch content in place.
4. Proposal content is clearly represented.
5. Workflow, database schema, and statistical analysis modules are visible from the first screen or top navigation.
6. No sensitive raw files are exposed.
7. GitHub repository exists under `dingchenchen6`.
8. GitHub Pages publishes successfully or the remaining manual Pages setting is explicitly documented.
9. README explains the project and how to preview the site locally.

## 13. Verification Plan

Local verification:

- Open the site in the in-app browser.
- Check desktop viewport.
- Check mobile viewport.
- Test all mode tabs.
- Test language switching.
- Confirm hash navigation.
- Confirm no console errors if browser tooling is available.

GitHub verification:

- Confirm remote repository URL.
- Push `main`.
- Confirm GitHub Pages source is root or document the manual setting.
- Visit the published URL after deployment.

## 14. Open Assumptions

The implementation will proceed with these assumptions unless changed:

- The site is public.
- The target GitHub account is `dingchenchen6`.
- The repository name is `tw-cvii-camera-trap-china`.
- The first version is static HTML/CSS/JS without a build system.
- The first version uses framework/example visuals, not real analysis results.
- Sensitive coordinates and raw full texts stay out of GitHub.
