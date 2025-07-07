select *  from employee_location_match_view



CREATE VIEW employee_location_match_view AS

SELECT
    e.id AS employee_id,
    e.geom AS geom, -- *** هذا هو عمود الهندسة الخاص بموقع الموظف، ضروري لـ QGIS ***
    c.id AS company_id,
    c.name AS company_name,
    employee_boro.boro_name AS employee_borough_name,
    company_boro.boro_name AS company_borough_name,
    CASE
        WHEN employee_boro.boro_name = company_boro.boro_name THEN 'same'
        ELSE 'other'
    END AS location_match_status
FROM
    employee AS e
JOIN
    company AS c ON e.company_id = c.id
LEFT JOIN
    boro AS employee_boro ON ST_Contains(employee_boro.geom, e.geom)
LEFT JOIN
    boro AS company_boro ON ST_Contains(company_boro.geom, c.geom);