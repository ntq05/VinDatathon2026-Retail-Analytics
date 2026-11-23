from pathlib import Path
import dagster as dg
from retail_intelligence.ingestion.csv_loader import ingest_csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]

RAW_DIR = PROJECT_ROOT / "data" / "raw"
DB_PATH = PROJECT_ROOT / "data" / "warehouse" / "retail.duckdb"

def create_bronze_asset(csv_path: Path):

    @dg.asset(
        name = csv_path.stem.lower(),
        key_prefix = ['bronze'],
        group_name = "bronze",
        description = f"Ingest {csv_path.name} into DuckDB Bronze",
    )
    def bronze_asset(context: dg.AssetExecutionContext):
        result = ingest_csv(
            file_path=csv_path,
            db_path=DB_PATH
        )

        context.add_output_metadata({
            "table": result['table'],
            "source_file": result['source_file'],
            "row_count": result['row_count'],
            "checksum": result['checksum']
        })

    return bronze_asset

bronze_assets = [
    create_bronze_asset(csv_path)
    for csv_path in sorted(RAW_DIR.glob("*.csv"))
]