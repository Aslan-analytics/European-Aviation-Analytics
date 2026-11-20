SELECT
    year,
    COUNT(*) AS total_rows,
    MIN(flt_date) AS first_date,
    MAX(flt_date) AS last_date
FROM airport_delays
GROUP BY year
ORDER BY year;

SELECT
    year,
    COUNT(*) AS total_rows,
    COUNT(dly_all_pre_2) AS rows_with_delay,
    ROUND(
        COUNT(dly_all_pre_2) * 100.0 / COUNT(*),
        2
    ) AS data_coverage_pct
FROM airport_delays
GROUP BY year
ORDER BY year;

SELECT
    t.flt_date,
    t.apt_name,
    t.state_name,
    t.flt_tot_1 AS total_movements,
    d.flt_dep_ifr_2 AS ifr_departures,
    d.dly_all_pre_2 AS delay_value
FROM airport_traffic AS t
LEFT JOIN airport_delays AS d
    ON t.flt_date = d.flt_date
    AND t.apt_icao = d.apt_icao
WHERE t.apt_icao = 'LKPR'
ORDER BY t.flt_date
LIMIT 10;

SELECT
    COUNT(*) AS joined_rows,
    COUNT(d.dly_all_pre_2) AS rows_with_delay
FROM airport_traffic AS t
LEFT JOIN airport_delays AS d
    ON t.flt_date = d.flt_date
    AND t.apt_icao = d.apt_icao;

	SELECT
    year,
    ROUND(
        SUM(dly_all_pre_2) /
        NULLIF(SUM(flt_dep_ifr_2), 0),
        2
    ) AS avg_delay_minutes
FROM airport_delays
WHERE apt_icao = 'LKPR'
  AND dly_all_pre_2 IS NOT NULL
GROUP BY year
ORDER BY year;

  
SELECT
    apt_icao,
    apt_name,
    state_name,
    SUM(flt_dep_ifr_2) AS total_ifr_departures,
    ROUND(
        SUM(dly_all_pre_2) /
        NULLIF(SUM(flt_dep_ifr_2), 0),
        2
    ) AS avg_delay_minutes
FROM airport_delays
WHERE year = 2025
    AND dly_all_pre_2 IS NOT NULL
GROUP BY apt_icao, apt_name, state_name
HAVING SUM(flt_dep_ifr_2) >= 10000
ORDER BY avg_delay_minutes DESC
LIMIT 10;


SELECT
    year,
    ROUND(
        SUM(dly_all_pre_2) / NULLIF(SUM(flt_dep_ifr_2), 0),
        2
    ) AS avg_delay_minutes
FROM airport_delays
WHERE apt_icao = 'ELLX'
    AND year IN (2024, 2025)
    AND dly_all_pre_2 IS NOT NULL
GROUP BY year
ORDER BY year;

SELECT
    flt_date,
    apt_icao,
    COUNT(*) AS duplicate_count
FROM airport_delays
GROUP BY flt_date, apt_icao
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT
    COUNT(*) AS total_rows,
    COUNT(dly_all_pre_2) AS rows_with_delay,
    COUNT(*) - COUNT(dly_all_pre_2) AS missing_delay
FROM airport_delays;

WITH yearly_delays AS (
    SELECT
        apt_icao,
        apt_name,
        state_name,
        year,
        SUM(dly_all_pre_2) /
            NULLIF(SUM(flt_dep_ifr_2), 0) AS avg_delay
    FROM airport_delays
    WHERE year IN (2024, 2025)
      AND dly_all_pre_2 IS NOT NULL
    GROUP BY apt_icao, apt_name, state_name, year
),
airport_comparison AS (
    SELECT
        apt_icao,
        apt_name,
        state_name,
        MAX(CASE WHEN year = 2024 THEN avg_delay END) AS delay_2024,
        MAX(CASE WHEN year = 2025 THEN avg_delay END) AS delay_2025
    FROM yearly_delays
    GROUP BY apt_icao, apt_name, state_name
)
SELECT
    apt_icao,
    apt_name,
    state_name,
    ROUND(delay_2024, 2) AS delay_2024,
    ROUND(delay_2025, 2) AS delay_2025,
    ROUND(delay_2025 - delay_2024, 2) AS change_minutes,
    ROUND(
        (delay_2025 - delay_2024) * 100 /
        NULLIF(delay_2024, 0),
        2
    ) AS change_pct
FROM airport_comparison
WHERE delay_2024 IS NOT NULL
  AND delay_2025 IS NOT NULL
ORDER BY change_minutes DESC;
