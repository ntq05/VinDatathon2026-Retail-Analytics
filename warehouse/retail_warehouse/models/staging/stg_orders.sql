WITH source AS (
    SELECT * 
    FROM {{ source('bronze', 'orders') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(order_id), '') AS order_id,
        TRY_CAST(order_date AS DATE) AS order_date,
        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(zip), '') AS zip,

        LOWER(NULLIF(TRIM(order_status), '')) AS order_status,
        LOWER(NULLIF(TRIM(payment_method), '')) AS payment_method,
        LOWER(NULLIF(TRIM(device_type), '')) AS device_type,
        LOWER(NULLIF(TRIM(order_source), '')) AS order_source

    FROM source
)

SELECT * 
FROM cleaned