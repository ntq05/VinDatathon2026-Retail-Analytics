WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'customers') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(zip), '') AS zip,

        LOWER(NULLIF(TRIM(city), '')) AS city,

        TRY_CAST(NULLIF(TRIM(signup_date), '') AS DATE) AS signup_date,

        LOWER(NULLIF(TRIM(gender), '')) AS gender,

        NULLIF(TRIM(age_group), '') AS age_group,

        LOWER(NULLIF(TRIM(acquisition_channel), '')) AS acquisition_channel

    FROM source
)

SELECT *
FROM cleaned
