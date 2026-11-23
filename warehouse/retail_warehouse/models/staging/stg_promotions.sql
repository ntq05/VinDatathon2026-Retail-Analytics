
WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'promotions') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(promo_id), '') AS promo_id,
        NULLIF(TRIM(promo_name), '') AS promo_name,

        LOWER(NULLIF(TRIM(promo_type), '')) AS promo_type,

        TRY_CAST(
            NULLIF(TRIM(discount_value), '')
            AS DECIMAL(18, 2)
        ) AS discount_value,

        TRY_CAST(
            NULLIF(TRIM(start_date), '')
            AS DATE
        ) AS start_date,

        TRY_CAST(
            NULLIF(TRIM(end_date), '')
            AS DATE
        ) AS end_date,

        CASE
            WHEN LOWER(TRIM(applicable_category)) IN ('none', '')
                THEN NULL
            ELSE LOWER(TRIM(applicable_category))
        END AS applicable_category,

        LOWER(NULLIF(TRIM(promo_channel), ''))
            AS promo_channel,

        TRY_CAST(
            NULLIF(TRIM(stackable_flag), '')
            AS INTEGER
        ) AS stackable_flag,

        TRY_CAST(
            NULLIF(TRIM(min_order_value), '')
            AS DECIMAL(18, 2)
        ) AS min_order_value

    FROM source
)

SELECT *
FROM cleaned
