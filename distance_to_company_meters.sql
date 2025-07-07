SELECT
    el.id AS employee_id,
    el.geom AS employee_location,
    c.id AS company_id,
    c.name AS company_name,
    ST_Distance(el.geom, c.geom) AS distance_to_company_meters,
    CASE
        WHEN ST_DWithin(el.geom, c.geom, 500) THEN '0-500m'
        WHEN ST_DWithin(el.geom, c.geom, 1000) THEN '501-1000m'
        WHEN ST_DWithin(el.geom, c.geom, 1500) THEN '1001-1500m'
        WHEN ST_DWithin(el.geom, c.geom, 2000) THEN '1501-2000m'
        WHEN ST_DWithin(el.geom, c.geom, 3000) THEN '2001-3000m'
        ELSE 'Beyond 3000m'
    END AS proximity_band
FROM
    emp_location el
JOIN
    "HRDATA" hr ON el.id = hr.id
JOIN
    company c ON ST_DWithin(el.geom, c.geom, 3000)
WHERE
    hr."Attrition" = false;