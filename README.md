# TW-CVII China Research Website

This repository hosts a bilingual GitHub Pages website for the Threat-weighted Camera-trap Vertebrate Intactness Index for China project.

## Website Modules

- `Research`: proposal, evidence states, and TW-CVII conceptual framework.
- `Workflow`: literature search, Zotero/OneFind knowledge base, AI-assisted extraction, verification, standardization, and QA gates.
- `Database`: PREDICTS / DiVert / Camtrap DP-aligned camera-trap database schema.
- `Analysis`: TW-CVII analysis views, protected-area comparison, silent-range and monitoring-gap outputs.

## Executable Workflow

The repository now contains a working candidate workflow base:

- `08_database/schema/tables.json`: machine-readable relational schema.
- `08_database/schema/critical_field_dictionary.md`: required literature, locality, coordinate, time, camera-effort, species, and disturbance fields.
- `08_database/templates/*.csv`: standardized extraction templates.
- `05_extraction_raw/prompts/camera_trap_extraction_prompt.md`: AI/manual extraction prompt.
- `09_analysis/scripts/generate_workflow_templates.py`: regenerate CSV headers.
- `09_analysis/scripts/load_seed_qingliangfeng.py`: load the first open PDF seed extraction.
- `09_analysis/scripts/validate_workflow.py`: structural QA gate validator.
- `09_analysis/scripts/build_sqlite_database.py`: build a local SQLite candidate database.
- `08_database/releases/camera_trap_candidate.sqlite`: current candidate database release.

Current seed extraction:

- `SRC000001`: Guo et al. 2022, Zhejiang Qingliangfeng National Nature Reserve.
- Candidate rows: 1 source, 1 study, 3 blocks, 4 sites, 4 deployment aggregates, 54 species, 54 species-site RAI measurements, 5 disturbance records.
- Important caveat: values are `candidate`; Appendix 1, Zotero item key, external taxonomy, and high-impact fields still require human verification.

Run the executable workflow:

```bash
python3 09_analysis/scripts/generate_workflow_templates.py --force
python3 09_analysis/scripts/load_seed_qingliangfeng.py
python3 09_analysis/scripts/validate_workflow.py --report
python3 09_analysis/scripts/build_sqlite_database.py
```

## Local Preview

```bash
python3 -m http.server 8080
```

Open:

```text
http://localhost:8080/
```

## Public Site

Expected GitHub Pages URL:

```text
https://dingchenchen6.github.io/tw-cvii-camera-trap-china/
```

## Data Boundary

This public site does not publish raw copyrighted PDFs, Zotero local data, restricted datasets, exact sensitive wildlife coordinates, private notes, or raw camera media. It publishes only the research framework, workflow, schema, non-sensitive examples, and analysis plan.

## Source Frameworks

- Camtrap DP: https://camtrap-dp.tdwg.org/data/
- GBIF camera-trap guide: https://docs.gbif.org/camera-trap-guide/en/
- PREDICTS database: https://doi.org/10.1002/ece3.2579
- DiVert: https://doi.org/10.1111/geb.70261
