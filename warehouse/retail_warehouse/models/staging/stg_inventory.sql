
WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'inventory') }}
),

cleaned AS (
    SELECT
        -- Snapshot date and product identifier
        TRY_CAST(NULLIF(TRIM(snapshot_date), '') AS DATE) AS snapshot_date,
        NULLIF(TRIM(product_id), '') AS product_id,

        -- Inventory quantities
        TRY_CAST(NULLIF(TRIM(stock_on_hand), '') AS INTEGER) AS stock_on_hand,
        TRY_CAST(NULLIF(TRIM(units_received), '') AS INTEGER) AS units_received,
        TRY_CAST(NULLIF(TRIM(units_sold), '') AS INTEGER) AS units_sold,
        TRY_CAST(NULLIF(TRIM(stockout_days), '') AS INTEGER) AS stockout_days,

        -- Inventory metrics
        TRY_CAST(NULLIF(TRIM(days_of_supply), '') AS DOUBLE) AS days_of_supply,
        TRY_CAST(NULLIF(TRIM(fill_rate), '') AS DOUBLE) AS fill_rate,
        TRY_CAST(NULLIF(TRIM(sell_through_rate), '') AS DOUBLE) AS sell_through_rate,

        -- Inventory flags
        TRY_CAST(NULLIF(TRIM(stockout_flag), '') AS INTEGER) AS stockout_flag,
        TRY_CAST(NULLIF(TRIM(overstock_flag), '') AS INTEGER) AS overstock_flag,
        TRY_CAST(NULLIF(TRIM(reorder_flag), '') AS INTEGER) AS reorder_flag,

        -- Product attributes
        NULLIF(TRIM(product_name), '') AS product_name,
        LOWER(NULLIF(TRIM(category), '')) AS category,
        LOWER(NULLIF(TRIM(segment), '')) AS segment,

        -- Time attributes
        TRY_CAST(NULLIF(TRIM(year), '') AS INTEGER) AS year,
        TRY_CAST(NULLIF(TRIM(month), '') AS INTEGER) AS month

    FROM source
)

SELECT *
FROM cleaned
