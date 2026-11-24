WITH order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

products AS (

    SELECT
        product_id,
        cogs
    FROM {{ ref('dim_products') }}

),

joined AS (

    SELECT
        oi.order_id,
        oi.product_id,

        o.order_date,
        o.customer_id,
        o.zip,

        o.order_status,
        o.payment_method,
        o.device_type,
        o.order_source,

        oi.promo_id,
        oi.promo_id_2,

        oi.quantity,
        oi.unit_price,
        oi.discount_amount,

        p.cogs

    FROM order_items AS oi

    LEFT JOIN orders AS o
        ON oi.order_id = o.order_id

    LEFT JOIN products AS p
        ON oi.product_id = p.product_id

),

base_metrics AS (

    SELECT
        *,

        ROUND(
            quantity * unit_price,
            2
        ) AS line_revenue,

        ROUND(
            quantity * cogs,
            2
        ) AS line_cost,

        CASE
            WHEN promo_id IS NOT NULL
                AND TRIM(promo_id) <> ''
            THEN 1
            ELSE 0
        END AS has_promo

    FROM joined

),

profit_metrics AS (

    SELECT
        *,

        ROUND(
            line_revenue - line_cost,
            2
        ) AS line_gross_profit

    FROM base_metrics

),

final AS (

    SELECT
        *,

        CASE
            WHEN line_revenue > 0
            THEN ROUND(
                line_gross_profit / line_revenue * 100,
                2
            )
            ELSE 0
        END AS line_margin_pct,

        CASE
            WHEN line_revenue + discount_amount > 0
            THEN ROUND(
                discount_amount
                / (line_revenue + discount_amount) * 100,
                2
            )
            ELSE 0
        END AS discount_pct

    FROM profit_metrics

)

SELECT *
FROM final