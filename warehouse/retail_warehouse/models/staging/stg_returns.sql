WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'returns') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(return_id), '') AS return_id,
        NULLIF(TRIM(order_id), '') AS order_id,
        NULLIF(TRIM(product_id), '') AS product_id,

        TRY_CAST(
            NULLIF(TRIM(return_date), '')
            AS DATE
        ) AS return_date,

        LOWER(NULLIF(TRIM(return_reason), '')) AS return_reason,

        TRY_CAST(
            NULLIF(TRIM(return_quantity), '')
            AS INTEGER
        ) AS return_quantity,

        TRY_CAST(
            NULLIF(TRIM(refund_amount), '')
            AS DECIMAL(18, 2)
        ) AS refund_amount

    FROM source
)

SELECT *
FROM cleaned
