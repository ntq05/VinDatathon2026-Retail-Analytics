WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'products') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(product_name), '') AS product_name,
        LOWER(NULLIF(TRIM(category), '')) AS category,
        LOWER(NULLIF(TRIM(segment), '')) AS segment,
        NULLIF(TRIM(size), '') AS size,
        NULLIF(TRIM(color), '') AS color,

        TRY_CAST(NULLIF(TRIM(price), '') AS DECIMAL(18, 2)) AS price,
        TRY_CAST(NULLIF(TRIM(cogs), '') AS DECIMAL(18, 2)) AS cogs

    FROM source
)

SELECT *
FROM cleaned