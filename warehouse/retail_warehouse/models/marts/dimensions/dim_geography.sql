SELECT
    zip,
    city,
    region,
    district

FROM {{ ref('stg_geography') }}