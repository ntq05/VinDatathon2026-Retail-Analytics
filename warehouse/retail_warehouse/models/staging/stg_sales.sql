WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'sales') }}
),

cleaned AS (
    SELECT
        TRY_CAST(
            NULLIF(TRIM("Date"), '')
            AS DATE
        ) AS sales_date,

        TRY_CAST(
            NULLIF(TRIM("Revenue"), '')
            AS DECIMAL(18, 2)
        ) AS revenue,

        TRY_CAST(
            NULLIF(TRIM("COGS"), '')
            AS DECIMAL(18, 2)
        ) AS cogs

    FROM source
)

SELECT *
FROM cleaned
