#!/usr/bin/env python3
"""Generate empty workflow CSV templates from the TW-CVII table schema."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SCHEMA_PATH = ROOT / "08_database" / "schema" / "tables.json"
TEMPLATE_DIR = ROOT / "08_database" / "templates"


MANIFESTS = {
    "01_search/search_log.csv": [
        "search_id",
        "date",
        "database_or_source",
        "platform_access",
        "query_round",
        "query",
        "query_language",
        "result_count_observed",
        "records_exported",
        "export_file",
        "deduplicated_count",
        "status",
        "notes"
    ],
    "01_search/database_export_manifest.csv": [
        "export_id",
        "search_id",
        "database_or_source",
        "export_date",
        "export_format",
        "export_file",
        "record_count",
        "imported_to_zotero",
        "zotero_collection",
        "notes"
    ],
    "01_search/seed_records.csv": [
        "seed_id",
        "source_id",
        "title",
        "year",
        "language",
        "source",
        "doi",
        "url",
        "why_seed",
        "full_text_status",
        "supplement_status",
        "next_action",
        "provenance"
    ],
    "02_zotero/zotero_import_manifest.csv": [
        "zotero_batch_id",
        "source_file",
        "import_date",
        "collection",
        "items_imported",
        "duplicates_found",
        "notes"
    ],
    "03_full_text/pdf_manifest.csv": [
        "file_id",
        "source_id",
        "file_name",
        "file_path",
        "url",
        "download_date",
        "sha256",
        "file_type",
        "full_text_status",
        "ocr_status",
        "text_extract_path",
        "license_or_access_note",
        "notes"
    ],
    "03_full_text/no_full_text_reason.csv": [
        "source_id",
        "reason_code",
        "reason_detail",
        "checked_date",
        "next_attempt_date"
    ],
    "03_full_text/supplementary_manifest.csv": [
        "supplement_id",
        "source_id",
        "file_name",
        "file_path",
        "url",
        "download_date",
        "file_type",
        "supplement_type",
        "contains_species_list",
        "contains_deployment_data",
        "contains_metrics",
        "extraction_status",
        "notes"
    ],
    "04_screening/screening_decisions.csv": [
        "source_id",
        "screening_stage",
        "decision",
        "decision_date",
        "reviewer",
        "exclusion_reason",
        "include_for",
        "notes"
    ],
    "05_extraction_raw/extraction_batch_manifest.csv": [
        "batch_id",
        "date",
        "input_file_id",
        "source_id",
        "extractor",
        "tool_or_model",
        "prompt_version",
        "output_folder",
        "status",
        "notes"
    ],
    "07_cleaning/taxonomy_crosswalk.csv": [
        "taxon_name_entered",
        "scientific_name_accepted",
        "chinese_name_standard",
        "taxon_rank",
        "name_status",
        "taxonomy_source",
        "verification_status",
        "notes"
    ],
    "07_cleaning/location_crosswalk.csv": [
        "site_name_original",
        "site_name_standard",
        "protected_area_name",
        "province",
        "prefecture",
        "county",
        "latitude",
        "longitude",
        "coordinate_precision",
        "verification_status",
        "notes"
    ],
    "07_cleaning/metric_definitions.csv": [
        "metric_name_original",
        "metric_name_standard",
        "definition",
        "formula",
        "standard_unit",
        "denominator_required",
        "effort_sensitive",
        "notes"
    ]
}


def write_csv(path: Path, header: list[str], force: bool) -> bool:
    if path.exists() and not force:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(header)
    return True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true", help="overwrite existing templates")
    args = parser.parse_args()

    with SCHEMA_PATH.open(encoding="utf-8") as handle:
        schema = json.load(handle)

    created = []
    for table_name, table in schema["tables"].items():
        out = TEMPLATE_DIR / f"{table_name}.csv"
        if write_csv(out, table["columns"], args.force):
            created.append(out)

    for rel_path, header in MANIFESTS.items():
        out = ROOT / rel_path
        if write_csv(out, header, args.force):
            created.append(out)

    for path in created:
        print(path.relative_to(ROOT))
    if not created:
        print("No files created; use --force to overwrite existing templates.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
