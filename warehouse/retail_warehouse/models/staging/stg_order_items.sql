WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'order_items') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(order_id), '') AS order_id,

        TRY_CAST(NULLIF(TRIM(quantity), '') AS INTEGER) AS quantity,

        TRY_CAST(NULLIF(TRIM(unit_price), '') AS DECIMAL(18, 2)) AS unit_price,
        TRY_CAST(NULLIF(TRIM(discount_amount), '') AS DECIMAL(18, 2)) AS discount_amount,

        NULLIF(TRIM(promo_id), '') AS promo_id,
        NULLIF(TRIM(promo_id_2), '') AS promo_id_2

    FROM source
)

SELECT *
FROM cleaned
