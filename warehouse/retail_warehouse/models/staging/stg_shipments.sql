WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'shipments') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(order_id), '') AS order_id,

        TRY_CAST(
            NULLIF(TRIM(ship_date), '')
            AS DATE
        ) AS ship_date,

        TRY_CAST(
            NULLIF(TRIM(delivery_date), '')
            AS DATE
        ) AS delivery_date,

        TRY_CAST(
            NULLIF(TRIM(shipping_fee), '')
            AS DECIMAL(18, 2)
        ) AS shipping_fee

    FROM source
)

SELECT *
FROM cleaned
