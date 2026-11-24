WITH source_dates AS (

    SELECT order_date AS date_value
    FROM {{ ref('stg_orders') }}

    UNION ALL

    SELECT sales_date AS date_value
    FROM {{ ref('stg_sales') }}

),

date_bounds AS (

    SELECT
        MIN(date_value) AS min_date,
        MAX(date_value) AS max_date
    FROM source_dates

),

date_spine AS (

    SELECT
        CAST(
            UNNEST(
                GENERATE_SERIES(
                    min_date,
                    max_date,
                    INTERVAL '1 day'
                )
            ) AS DATE
        ) AS date_key

    FROM date_bounds

)

SELECT
    date_key,

    YEAR(date_key) AS year,
    MONTH(date_key) AS month,
    QUARTER(date_key) AS quarter,

    DAY(date_key) AS day_of_month,

    (DAYOFWEEK(date_key) + 6) % 7 AS day_of_week,

    STRFTIME(date_key, '%A') AS day_name,
    STRFTIME(date_key, '%B') AS month_name,
    STRFTIME(date_key, '%Y-%m') AS year_month

FROM date_spine