SELECT
    customer_id,
    zip,
    city,
    signup_date,
    gender,
    age_group,
    acquisition_channel

FROM {{ ref('stg_customers') }}