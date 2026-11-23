WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'reviews') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(review_id), '') AS review_id,
        NULLIF(TRIM(order_id), '') AS order_id,
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(customer_id), '') AS customer_id,

        TRY_CAST(
            NULLIF(TRIM(review_date), '')
            AS DATE
        ) AS review_date,

        TRY_CAST(
            NULLIF(TRIM(rating), '')
            AS INTEGER
        ) AS rating,

        NULLIF(TRIM(review_title), '') AS review_title

    FROM source
)

SELECT *
FROM cleaned
