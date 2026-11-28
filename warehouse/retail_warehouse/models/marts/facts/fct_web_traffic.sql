SELECT
    traffic_date,
    traffic_source,

    sessions,
    unique_visitors,
    page_views,

    bounce_rate,
    avg_session_duration_sec,

    ROUND(
        page_views / NULLIF(sessions, 0),
        2
    ) AS pages_per_session

FROM {{ ref('stg_web_traffic') }}
