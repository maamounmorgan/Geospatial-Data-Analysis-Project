
CREATE VIEW employees_per_boro AS
SELECT
    b.borough_na AS borough_name,
    COUNT(hr.id) AS total_employees
FROM
    boro b
LEFT JOIN
    "HRDATA" hr ON b.id = hr.boro_id -- تم تصحيح شرط الربط هنا!
GROUP BY
    b.borough_na
ORDER BY
    b.borough_na;