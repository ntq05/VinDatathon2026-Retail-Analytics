WITH returns AS (

    SELECT *
    FROM {{ ref('stg_returns') }}

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
        r.return_id,
        r.order_id,
        r.product_id,

        o.customer_id,
        o.zip,

        o.order_date,
        r.return_date,

        r.return_reason,
        r.return_quantity,
        r.refund_amount,

        DATE_DIFF('day', o.order_date, r.return_date) AS days_to_return

    FROM returns AS r

    LEFT JOIN orders AS o
        ON r.order_id = o.order_id

)

SELECT *
FROM final
