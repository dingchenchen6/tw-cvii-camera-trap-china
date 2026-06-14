#!/usr/bin/env python3
"""Build a local SQLite database from TW-CVII workflow CSV templates."""

from __future__ import annotations

import argparse
import csv
import json
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SCHEMA_PATH = ROOT / "08_database" / "schema" / "tables.json"
TEMPLATE_DIR = ROOT / "08_database" / "templates"
DEFAULT_OUT = ROOT / "08_database" / "releases" / "camera_trap_candidate.sqlite"


def quote_identifier(name: str) -> str:
    return '"' + name.replace('"', '""') + '"'


def read_rows(path: Path) -> tuple[list[str], list[dict[str, str]]]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        return list(reader.fieldnames or []), list(reader)


def create_table(conn: sqlite3.Connection, table_name: str, columns: list[str], primary_key: str) -> None:
    column_defs = []
    for column in columns:
        suffix = " PRIMARY KEY" if column == primary_key else ""
        column_defs.append(f"{quote_identifier(column)} TEXT{suffix}")
    sql = f"CREATE TABLE {quote_identifier(table_name)} ({', '.join(column_defs)})"
    conn.execute(sql)


def load_table(conn: sqlite3.Connection, table_name: str, columns: list[str], rows: list[dict[str, str]]) -> None:
    if not rows:
        return
    placeholders = ", ".join("?" for _ in columns)
    col_sql = ", ".join(quote_identifier(column) for column in columns)
    sql = f"INSERT INTO {quote_identifier(table_name)} ({col_sql}) VALUES ({placeholders})"
    conn.executemany(sql, [[row.get(column, "") for column in columns] for row in rows])


def add_metadata(conn: sqlite3.Connection, schema_version: str, row_counts: dict[str, int]) -> None:
    conn.execute("CREATE TABLE database_metadata (key TEXT PRIMARY KEY, value TEXT)")
    conn.execute("INSERT INTO database_metadata VALUES (?, ?)", ("schema_version", schema_version))
    conn.execute("INSERT INTO database_metadata VALUES (?, ?)", ("build_type", "candidate"))
    for table, count in row_counts.items():
        conn.execute("INSERT INTO database_metadata VALUES (?, ?)", (f"row_count_{table}", str(count)))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()

    with SCHEMA_PATH.open(encoding="utf-8") as handle:
        schema = json.load(handle)

    args.out.parent.mkdir(parents=True, exist_ok=True)
    if args.out.exists():
        args.out.unlink()

    row_counts: dict[str, int] = {}
    with sqlite3.connect(args.out) as conn:
        for table_name, table in schema["tables"].items():
            csv_path = TEMPLATE_DIR / f"{table_name}.csv"
            columns, rows = read_rows(csv_path)
            create_table(conn, table_name, columns, table["primary_key"])
            load_table(conn, table_name, columns, rows)
            row_counts[table_name] = len(rows)
        add_metadata(conn, schema["schema_version"], row_counts)

    print(args.out.relative_to(ROOT))
    for table, count in row_counts.items():
        if count:
            print(f"{table}: {count}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
