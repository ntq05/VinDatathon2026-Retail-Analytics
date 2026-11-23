WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'payments') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(order_id), '') AS order_id,

        LOWER(NULLIF(TRIM(payment_method), '')) AS payment_method,

        TRY_CAST(
            NULLIF(TRIM(payment_value), '')
            AS DECIMAL(18, 2)
        ) AS payment_value,

        TRY_CAST(
            NULLIF(TRIM(installments), '')
            AS INTEGER
        ) AS installments

    FROM source
)

SELECT *
FROM cleaned
