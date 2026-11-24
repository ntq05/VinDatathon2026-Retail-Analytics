WITH sales AS (

    SELECT
        sales_date,
        revenue,
        cogs
    FROM {{ ref('stg_sales') }}

),

base_metrics AS (

    SELECT
        *,

        ROUND(
            revenue - cogs,
            2
        ) AS gross_profit

    FROM sales

),

final AS (

    SELECT
        *,

        ROUND(
            gross_profit / NULLIF(revenue, 0) * 100,
            2
        ) AS gross_margin_pct

    FROM base_metrics

)

SELECT *
FROM final