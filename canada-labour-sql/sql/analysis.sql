-- Query 1: Unemployment rate by province (2024 average)
-- Shows which provinces had the highest unemployment in the most recent full year
SELECT
    GEO,
    ROUND(AVG(VALUE), 2) AS avg_unemployment_rate
FROM lfs_province
WHERE "Labour force characteristics" = 'Unemployment rate'
  AND REF_DATE LIKE '2024%'
  AND GEO NOT IN ('Canada', 'Northwest Territories', 'Yukon', 'Nunavut')
GROUP BY GEO
ORDER BY avg_unemployment_rate DESC;


-- Query 2: Ontario unemployment trend 2015–2024
-- Tracks month by month changes to identify long-term patterns
SELECT
    REF_DATE,
    ROUND(VALUE, 2) AS unemployment_rate
FROM lfs_province
WHERE "Labour force characteristics" = 'Unemployment rate'
  AND GEO = 'Ontario'
  AND REF_DATE >= '2015-01'
ORDER BY REF_DATE;

-- Query 3: COVID impact — compare 2019 vs 2020 unemployment by province
-- Highlights which provinces were hit hardest by the pandemic
SELECT
    GEO,
    ROUND(AVG(CASE WHEN REF_DATE LIKE '2019%' THEN VALUE END), 2)
        AS avg_2019,
    ROUND(AVG(CASE WHEN REF_DATE LIKE '2020%' THEN VALUE END), 2)
        AS avg_2020,
    ROUND(
        AVG(CASE WHEN REF_DATE LIKE '2020%' THEN VALUE END) -
        AVG(CASE WHEN REF_DATE LIKE '2019%' THEN VALUE END),
    2) AS change
FROM lfs_province
WHERE "Labour force characteristics" = 'Unemployment rate'
  AND GEO NOT IN ('Canada', 'Northwest Territories',
                   'Yukon', 'Nunavut')
GROUP BY GEO
ORDER BY change DESC;

--Query 4: Employment by industry (most recent year available)
-- Identifies the employment distribution across sectors in Canada
 SELECT DISTINCT
    "North American Industry Classification System (NAICS)" AS Industry,
    REF_DATE,
    VALUE AS employment_thousands
FROM lfs_industry
WHERE REF_DATE = (SELECT MAX(REF_DATE) FROM lfs_industry)
  AND "Labour force characteristics" = 'Employment'
  AND GEO = 'Canada'
ORDER BY VALUE DESC;

-- Query 5: Unemployment rate — month by month 2020–2024
-- Shows how the unemployement rate evolved during the pandemic and recovery period
SELECT
    REF_DATE,
    GEO,
    ROUND(VALUE, 2) AS unemployment_rate
FROM lfs_province
WHERE "Labour force characteristics" = 'Unemployment rate'
  AND REF_DATE BETWEEN '2020-01' AND '2022-12'
  AND GEO IN ('Ontario', 'Quebec', 'British Columbia', 'Alberta')
ORDER BY GEO, REF_DATE;
