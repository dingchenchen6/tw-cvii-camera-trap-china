#!/usr/bin/env python3
"""Validate TW-CVII workflow templates, manifests, and core database rules."""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SCHEMA_PATH = ROOT / "08_database" / "schema" / "tables.json"
TEMPLATE_DIR = ROOT / "08_database" / "templates"
REPORT_DIR = ROOT / "12_audits" / "qa_gate_reports"


REQUIRED_MANIFESTS = [
    "01_search/search_log.csv",
    "01_search/seed_records.csv",
    "03_full_text/pdf_manifest.csv",
    "03_full_text/supplementary_manifest.csv",
    "04_screening/screening_decisions.csv",
    "05_extraction_raw/extraction_batch_manifest.csv"
]


def read_csv(path: Path) -> tuple[list[str], list[dict[str, str]]]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        return list(reader.fieldnames or []), list(reader)


def add_issue(issues: list[dict[str, str]], gate: str, severity: str, message: str) -> None:
    issues.append({"gate": gate, "severity": severity, "message": message})


def validate_headers(schema: dict, issues: list[dict[str, str]]) -> None:
    for table_name, table in schema["tables"].items():
        path = TEMPLATE_DIR / f"{table_name}.csv"
        if not path.exists():
            add_issue(issues, "Gate 4 Extraction", "error", f"Missing template: {path.relative_to(ROOT)}")
            continue
        header, _rows = read_csv(path)
        if header != table["columns"]:
            add_issue(
                issues,
                "Gate 4 Extraction",
                "error",
                f"Header mismatch in {path.relative_to(ROOT)}",
            )


def validate_manifests(issues: list[dict[str, str]]) -> None:
    for rel in REQUIRED_MANIFESTS:
        path = ROOT / rel
        if not path.exists():
            add_issue(issues, "Gate 1 Search Completeness", "error", f"Missing manifest: {rel}")
            continue
        header, rows = read_csv(path)
        if not header:
            add_issue(issues, "Gate 1 Search Completeness", "error", f"Empty header: {rel}")
        if rel in {"01_search/search_log.csv", "01_search/seed_records.csv"} and not rows:
            add_issue(issues, "Gate 1 Search Completeness", "warning", f"No rows yet: {rel}")


def validate_table_rows(schema: dict, issues: list[dict[str, str]]) -> None:
    table_rows: dict[str, list[dict[str, str]]] = {}
    table_headers: dict[str, list[str]] = {}
    primary_key_values: dict[str, set[str]] = {}

    for table_name, table in schema["tables"].items():
        path = TEMPLATE_DIR / f"{table_name}.csv"
        if not path.exists():
            continue
        header, rows = read_csv(path)
        table_headers[table_name] = header
        table_rows[table_name] = rows
        pk = table["primary_key"]
        values = [row.get(pk, "").strip() for row in rows if any(row.values())]
        blanks = sum(1 for value in values if not value)
        if blanks:
            add_issue(issues, "Gate 5 Standardization", "error", f"{table_name}.{pk} has {blanks} blank primary keys")
        duplicates = [key for key, count in Counter(values).items() if key and count > 1]
        if duplicates:
            add_issue(issues, "Gate 5 Standardization", "error", f"{table_name}.{pk} duplicates: {', '.join(duplicates[:5])}")
        primary_key_values[table_name] = {value for value in values if value}

        for row_number, row in enumerate(rows, start=2):
            if not any(row.values()):
                continue
            for field in table.get("mandatory", []):
                value = row.get(field, "").strip()
                if value == "":
                    add_issue(issues, "Gate 4 Extraction", "error", f"{table_name}:{row_number} missing mandatory field {field}")

            verification = row.get("verification_status", "").strip()
            if "verification_status" in header and verification and verification not in schema["verification_status_values"]:
                add_issue(issues, "Gate 4 Extraction", "warning", f"{table_name}:{row_number} has non-standard verification_status={verification}")

    for table_name, table in schema["tables"].items():
        rows = table_rows.get(table_name, [])
        for fk_field, target in table.get("foreign_keys", {}).items():
            target_table, _target_field = target.split(".")
            allowed = primary_key_values.get(target_table, set())
            for row_number, row in enumerate(rows, start=2):
                value = row.get(fk_field, "").strip()
                if not value or value in {"NR", "NA", "UNK", "PENDING", "EXTRACTED_UNVERIFIED"}:
                    continue
                if allowed and value not in allowed:
                    add_issue(issues, "Gate 5 Standardization", "error", f"{table_name}:{row_number} {fk_field}={value} not found in {target}")


def validate_silent_range_rule(issues: list[dict[str, str]]) -> None:
    path = TEMPLATE_DIR / "evidence_state.csv"
    if not path.exists():
        return
    _header, rows = read_csv(path)
    for row_number, row in enumerate(rows, start=2):
        if row.get("evidence_state") != "silent_range":
            continue
        if row.get("historically_expected") != "yes" or row.get("contemporary_detected") != "no" or row.get("survey_adequacy_status") != "adequate":
            add_issue(
                issues,
                "Gate 6 Analysis-Ready Release",
                "error",
                f"evidence_state:{row_number} violates silent_range rule"
            )


def write_report(issues: list[dict[str, str]]) -> Path:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    report_path = REPORT_DIR / "workflow_validation_latest.md"
    errors = [issue for issue in issues if issue["severity"] == "error"]
    warnings = [issue for issue in issues if issue["severity"] == "warning"]
    lines = [
        "# Workflow Validation Report",
        "",
        f"Errors: {len(errors)}",
        f"Warnings: {len(warnings)}",
        "",
        "## Issues"
    ]
    if issues:
        for issue in issues:
            lines.append(f"- [{issue['severity']}] {issue['gate']}: {issue['message']}")
    else:
        lines.append("- No structural issues found.")
    report_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return report_path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", action="store_true", help="write markdown report")
    args = parser.parse_args()

    with SCHEMA_PATH.open(encoding="utf-8") as handle:
        schema = json.load(handle)

    issues: list[dict[str, str]] = []
    validate_headers(schema, issues)
    validate_manifests(issues)
    validate_table_rows(schema, issues)
    validate_silent_range_rule(issues)

    for issue in issues:
        print(f"{issue['severity'].upper()}: {issue['gate']}: {issue['message']}")
    if args.report:
        report_path = write_report(issues)
        print(f"report={report_path.relative_to(ROOT)}")

    return 1 if any(issue["severity"] == "error" for issue in issues) else 0


if __name__ == "__main__":
    raise SystemExit(main())
