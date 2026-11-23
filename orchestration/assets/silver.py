from pathlib import Path
from dagster_dbt import DbtProject, dbt_assets, DbtCliResource

PROJECT_ROOT = Path(__file__).resolve().parents[2]

DBT_PROJECT_DIR = PROJECT_ROOT / "warehouse" / "retail_warehouse"

dbt_project = DbtProject(
    project_dir = DBT_PROJECT_DIR,
    profiles_dir = DBT_PROJECT_DIR,
)

dbt_project.prepare_if_dev()

@dbt_assets(
    manifest = dbt_project.manifest_path,
    select = "staging",
)
def silver_assets(context, dbt: DbtCliResource):
    yield from dbt.cli(
        ['build'],
        context = context
    ).stream()