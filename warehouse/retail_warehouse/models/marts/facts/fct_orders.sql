WITH orders AS (

    SELECT
        order_id,
        order_date,
        customer_id,
        zip,
        order_status,
        payment_method,
        device_type,
        order_source

    FROM {{ ref('stg_orders') }}

),

payments AS (

    SELECT
        order_id,
        payment_value,
        installments

    FROM {{ ref('stg_payments') }}

)

SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.zip,

    o.order_status,
    o.payment_method,
    o.device_type,
    o.order_source,

    p.payment_value,
    p.installments

FROM orders AS o

LEFT JOIN payments AS p
    ON o.order_id = p.order_id