SELECT
    review_id,
    order_id,
    product_id,
    customer_id,
    review_date,

    rating,
    review_title,

    CASE
        WHEN rating <= 2 THEN 1
        ELSE 0
    END AS is_low_rating

FROM {{ ref('stg_reviews') }}
