WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'geography') }}
),

cleaned AS (
    SELECT
        NULLIF(TRIM(zip), '') AS zip,

        LOWER(NULLIF(TRIM(city), '')) AS city,

        LOWER(NULLIF(TRIM(region), '')) AS region,

        LOWER(NULLIF(TRIM(district), '')) AS district

    FROM source
)

SELECT *
FROM cleaned
