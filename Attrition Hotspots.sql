SELECT
    el.id,
    el.geom
FROM
    emp_location el
JOIN
    "HRDATA" hr ON el.id = hr.id
WHERE
    hr."Attrition" = true;