# VinDatathon 2026

## Instruction

Create conda environment
```bash
conda create --prefix ./env python=3.11
```

Activate conda environment:
```bash
conda activate ./env
```

Install required packages
```bash
pip install -r requirements.txt
```

To work with dbt in data warehouse. First, move to warehouse/retail_warehouse
```bash
cd warehouse/retail_warehouse
```

Install dbt package dependencies, if applicable:
```bash
dbt deps
```

Verify the Snowflake connection:
```bash
dbt debug
```
Generate the project manifest:
```bash
dbt parse
```

Run dbt Models

Execute all transformation models:
```bash
dbt run
```
Execute models within a specific layer:
```bash
dbt run --select silver
dbt run --select gold
```
Execute a specific model:
```bash
dbt run --select model_name
```
Execute a model and all its upstream dependencies:
```bash
dbt run --select +model_name
```
Data Quality Testing

Run all configured data quality tests:
```bash
dbt test
```
Build models and execute their associated tests in dependency order:
```bash
dbt build
```
Documentation and Data Lineage

Generate project documentation:
```bash
dbt docs generate
```
Launch the documentation website:
```bash
dbt docs serve
```
The documentation provides model descriptions, column definitions, dependencies, and data lineage.

Dagster Integration

dbt models are integrated with Dagster as software-defined assets, allowing transformation workflows to be orchestrated and monitored alongside the data ingestion pipeline.

Start the Dagster development server from the configured orchestration directory:
```bash
dagster dev
```
Access the Dagster UI at http://localhost:3000 to materialize assets and monitor pipeline executions.