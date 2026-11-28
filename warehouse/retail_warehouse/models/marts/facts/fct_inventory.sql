WITH inventory AS (

    SELECT
        snapshot_date,
        product_id,

        stock_on_hand,
        units_received,
        units_sold,
        stockout_days,

        days_of_supply,
        fill_rate,
        sell_through_rate,

        stockout_flag,
        overstock_flag,
        reorder_flag

    FROM {{ ref('stg_inventory') }}

),

products AS (

    SELECT
        product_id,
        cogs
    FROM {{ ref('dim_products') }}

),

final AS (

    SELECT
        i.*,

        ROUND(
            i.stock_on_hand * p.cogs,
            2
        ) AS stock_value_at_cost

    FROM inventory AS i

    LEFT JOIN products AS p
        ON i.product_id = p.product_id

)

SELECT *
FROM final
