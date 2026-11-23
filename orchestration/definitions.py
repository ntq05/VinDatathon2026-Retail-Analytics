import dagster as dg

from orchestration.assets.bronze import bronze_assets
from orchestration.assets.silver import silver_assets, dbt_project

from dagster_dbt import DbtCliResource

bronze_job = dg.define_asset_job(
    name = "bronze_ingestion",
    selection = dg.AssetSelection.groups("bronze"),
    executor_def = dg.in_process_executor
)

silver_job = dg.define_asset_job(
    name = "silver_transformation",
    selection = dg.AssetSelection.assets(silver_assets),
    executor_def = dg.in_process_executor
)

defs = dg.Definitions(
    assets = [*bronze_assets, silver_assets],
    jobs = [bronze_job, silver_job],
    resources = {
        "dbt": DbtCliResource(
            project_dir = dbt_project,
        )
    }
)