

SELECT
    el.id AS employee_id,
    el.geom AS employee_location_geom,
    hr.id AS hr_id,
    hr."Attrition",
    c.id AS company_id,
    c.name AS company_name,
    ST_Distance(el.geom, c.geom) AS distance_meters
FROM
    emp_location el
JOIN
    "HRDATA" hr ON el.id = hr.id
JOIN
    company c ON ST_DWithin(el.geom, c.geom, 3000)
WHERE
    hr."Attrition" = FALSE;