WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'web_traffic') }}
),

cleaned AS (
    SELECT
        TRY_CAST(
            NULLIF(TRIM(date), '')
            AS DATE
        ) AS traffic_date,

        TRY_CAST(
            NULLIF(TRIM(sessions), '')
            AS INTEGER
        ) AS sessions,

        TRY_CAST(
            NULLIF(TRIM(unique_visitors), '')
            AS INTEGER
        ) AS unique_visitors,

        TRY_CAST(
            NULLIF(TRIM(page_views), '')
            AS INTEGER
        ) AS page_views,

        TRY_CAST(
            NULLIF(TRIM(bounce_rate), '')
            AS DOUBLE
        ) AS bounce_rate,

        TRY_CAST(
            NULLIF(TRIM(avg_session_duration_sec), '')
            AS DOUBLE
        ) AS avg_session_duration_sec,

        LOWER(NULLIF(TRIM(traffic_source), '')) AS traffic_source

    FROM source
)

SELECT *
FROM cleaned
