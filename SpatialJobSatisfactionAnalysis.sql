
CREATE VIEW SpatialJobSatisfactionAnalysis AS
SELECT
    b.borough_na AS borough_name,
    company_data.company_name,
    street_data.street_name,
    hr."Job Role" AS job_role,
    hr."Job Satisfaction" AS job_satisfaction_rating, -- تم تصحيح اسم العمود هنا
    COUNT(hr.id) AS employee_count
FROM
    "HRDATA" hr
JOIN
    emp_location el ON hr.id = el.id
JOIN
    boro b ON ST_Contains(b.geom, el.geom)
JOIN LATERAL (
    SELECT
        c.name AS company_name,
        ST_Distance(el.geom, c.geom) AS distance_to_company
    FROM
        company c
    ORDER BY
        ST_Distance(el.geom, c.geom)
    LIMIT 1
) AS company_data ON TRUE
JOIN LATERAL (
    SELECT
        s.name AS street_name,
        ST_Distance(el.geom, s.geom) AS distance_to_street
    FROM
        str s
    ORDER BY
        ST_Distance(el.geom, s.geom)
    LIMIT 1
) AS street_data ON TRUE
GROUP BY
    b.borough_na,
    company_data.company_name,
    street_data.street_name,
    hr."Job Role",
    hr."Job Satisfaction" -- يجب أن يتطابق مع الاسم في الـ SELECT
ORDER BY
    b.borough_na,
    company_data.company_name,
    street_data.street_name,
    hr."Job Role",
    hr."Job Satisfaction"; -- يجب أن يتطابق مع الاسم في الـ SELECT