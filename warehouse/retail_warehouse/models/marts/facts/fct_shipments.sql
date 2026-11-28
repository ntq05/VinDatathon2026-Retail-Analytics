WITH shipments AS (

    SELECT *
    FROM {{ ref('stg_shipments') }}

),

orders AS (

    SELECT
        order_id,
        order_date,
        customer_id,
        zip
    FROM {{ ref('stg_orders') }}

),

final AS (

    SELECT
        s.order_id,

        o.customer_id,
        o.zip,

        o.order_date,
        s.ship_date,
        s.delivery_date,

        s.shipping_fee,

        DATE_DIFF('day', o.order_date, s.ship_date) AS days_to_ship,
        DATE_DIFF('day', s.ship_date, s.delivery_date) AS days_in_transit,
        DATE_DIFF('day', o.order_date, s.delivery_date) AS days_to_deliver

    FROM shipments AS s

    LEFT JOIN orders AS o
        ON s.order_id = o.order_id

)

SELECT *
FROM final
