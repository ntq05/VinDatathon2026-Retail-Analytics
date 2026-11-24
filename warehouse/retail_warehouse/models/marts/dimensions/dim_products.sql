SELECT
    product_id,
    product_name,
    category,
    segment,
    size,
    color,
    price,
    cogs

FROM {{ ref('stg_products') }}