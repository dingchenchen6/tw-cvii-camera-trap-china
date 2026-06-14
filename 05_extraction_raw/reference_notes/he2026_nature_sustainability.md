# Reference Note: He et al. 2026 Nature Sustainability

## Citation

He, J., Zhang, L., Yu, J., Wang, F., Xiao, Z. & Liu, J. (2026). Widespread range contraction of carnivores in protected areas of China. *Nature Sustainability*. https://doi.org/10.1038/s41893-026-01855-2

## Why It Matters for TW-CVII

This paper is a high-impact national reference for comparing historical mammal distributions with contemporary protected-area survey evidence. It directly informs the TW-CVII logic for:

- historical expectation baselines;
- contemporary camera-trap and survey evidence;
- protected-area performance;
- carnivore versus ungulate sensitivity;
- silent-range interpretation under adequate survey effort.

## Extraction-Relevant Facts to Verify From Supplementary Data

- Historical period: 1950-1970.
- Contemporary survey period: 2008-2021.
- Spatial scope: protected areas across China.
- Taxonomic scope: large and medium-sized mammals, with carnivores and ungulates separated.
- Survey effort fields: camera-trap days, number of protected areas, species-site detection/non-detection matrix.
- Reported public summary values to verify from data: 85 protected areas, more than 1.8 million camera-trap days, 82 mammal species.

## TW-CVII Table Mapping

- `source`: article metadata, DOI, publication date, rights status.
- `study`: national historical-current comparison design.
- `site`: protected-area units; exact coordinates should remain precision-coded.
- `species_site_measurement`: species-by-protected-area contemporary detection state if supplementary data permit extraction.
- `historical_expectation`: historical presence in protected-area units.
- `survey_adequacy_detection`: effort by protected area and guild.
- `evidence_state`: confirmed persistence versus silent range versus monitoring gap.
- `protected_area_context`: protected-area identity, region, and management context.
- `derived_index`: protected-area intactness and carnivore-specific contraction summaries.

## Public-Website Use Rule

Do not reuse article figures on GitHub Pages. The Nature page states that Springer Nature or its licensor holds exclusive rights to the article under the publishing agreement. Use original project diagrams and cite the article as a method/reference case only.

## Next Actions

1. Download supplementary PDF and Supplementary Data 1 only for permitted research use.
2. Register raw files in `03_full_text/supplementary_manifest.csv` and keep them out of public web assets.
3. Inspect whether species-by-protected-area data include coordinates, PA names, effort, historical status and contemporary detection.
4. Convert extraction candidates into `historical_expectation`, `survey_adequacy_detection`, and `evidence_state` tables.
5. Add claim-level audit rows before using any national contraction value in the manuscript.
