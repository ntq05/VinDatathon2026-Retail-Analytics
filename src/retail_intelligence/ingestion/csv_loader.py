from pathlib import Path
import hashlib
import re
from datetime import datetime, timezone
import duckdb

def compute_checksum(file_path: Path) -> str:
    """Calculate SHA256 checksum of a source file"""
    sha256 = hashlib.sha256()

    with file_path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            sha256.update(chunk)

    return sha256.hexdigest()

def ingest_csv(file_path: Path, db_path: Path) -> dict:
    """Load one CSV into DuckDB Bronze using full refresh"""
    file_path = Path(file_path)
    db_path = Path(db_path)

    if not file_path.is_file():
        raise FileNotFoundError(file_path)

    table_name = file_path.stem.lower()

    if not re.fullmatch("[a-z_][a-z0-9_]*", table_name):
        raise ValueError(f"Invalid table name: {table_name}")

    db_path.parent.mkdir(parents = True, exist_ok = True)

    check_sum = compute_checksum(file_path)
    ingested_at = datetime.now(timezone.utc).replace(tzinfo = None)

    with duckdb.connect(str(db_path)) as conn:
        conn.execute("CREATE SCHEMA IF NOT EXISTS bronze")

        conn.execute("BEGIN TRANSACTION")

        try:
            conn.execute(
                f"""
CREATE OR REPLACE TABLE bronze."{table_name}" AS
SELECT
*,
?::VARCHAR AS _source_file,
?::VARCHAR AS _source_checksum,
?::TIMESTAMP AS _ingested_at
FROM read_csv(
    ?,
    header = true,
    all_varchar = true
)
""",
        [
            file_path.name,
            check_sum,
            ingested_at,
            str(file_path.resolve())
        ]        
    )
            row_count = conn.execute(
                f'SELECT COUNT(*) FROM bronze."{table_name}"'
            ).fetchone()[0]

            conn.execute("COMMIT")
        except Exception:
            conn.execute("ROLLBACK")
            raise

    return {
        "table": f"bronze.{table_name}",
        "source_file": file_path.name,
        "row_count": row_count,
        "checksum": check_sum,
        "ingested_at": ingested_at.isoformat()
    }