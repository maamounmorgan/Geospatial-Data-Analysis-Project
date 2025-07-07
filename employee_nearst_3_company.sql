select * from employee_nearst_3_company_x_y


DROP VIEW IF EXISTS employee_nearst_3_company_x_y;

CREATE VIEW employee_nearst_3_company_x_y AS
SELECT
    e.id AS Employee_ID,
    e.boro_name AS emp_boro,
    current_company.name AS Current_Company,
    ST_AsText(e.geom) AS Employee_WKT,
    ST_X(e.geom) AS Employee_X,
    ST_Y(e.geom) AS Employee_Y,
    ST_AsText(current_company.geom) AS Current_Company_WKT,
    ST_X(current_company.geom) AS Company_X,
    ST_Y(current_company.geom) AS Company_Y,
    nearest1.name AS Nearest_Other_Company_1_Name,
    ST_AsText(nearest1.geom) AS Nearest_Other_Company_1_WKT,
    ST_X(nearest1.geom) AS Nearest_Other_Company_1_X,
    ST_Y(nearest1.geom) AS Nearest_Other_Company_1_Y,
    ST_Distance(ST_Transform(e.geom, 4326)::geography, ST_Transform(nearest1.geom, 4326)::geography) AS Distance_To_Nearest_Other_Company_1_Meters,
    nearest2.name AS Nearest_Other_Company_2_Name,
    ST_AsText(nearest2.geom) AS Nearest_Other_Company_2_WKT,
    ST_X(nearest2.geom) AS Nearest_Other_Company_2_X,
    ST_Y(nearest2.geom) AS Nearest_Other_Company_2_Y,
    ST_Distance(ST_Transform(e.geom, 4326)::geography, ST_Transform(nearest2.geom, 4326)::geography) AS Distance_To_Nearest_Other_Company_2_Meters,
    nearest3.name AS Nearest_Other_Company_3_Name,
    ST_AsText(nearest3.geom) AS Nearest_Other_Company_3_WKT,
    ST_X(nearest3.geom) AS Nearest_Other_Company_3_X,
    ST_Y(nearest3.geom) AS Nearest_Other_Company_3_Y,
    ST_Distance(ST_Transform(e.geom, 4326)::geography, ST_Transform(nearest3.geom, 4326)::geography) AS Distance_To_Nearest_Other_Company_3_Meters,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM company AS c_check
            WHERE c_check.id = current_company.id
            ORDER BY ST_Distance(ST_Transform(e.geom, 4326)::geography, ST_Transform(c_check.geom, 4326)::geography), c_check.id -- أضفنا c_check.id كقاطع تعادل
            LIMIT 3
        ) THEN TRUE
        ELSE FALSE
    END AS Is_Current_Company_Among_Top_3_Closest
FROM
    employee AS e
JOIN
    company AS current_company ON e.company_id = current_company.id
CROSS JOIN LATERAL (
    SELECT
        c.name,
        c.geom
    FROM
        company AS c
    WHERE
        c.id <> e.company_id
    ORDER BY
        e.geom <-> c.geom, c.id -- **قاطع التعادل هنا**
    LIMIT 1
) AS nearest1
CROSS JOIN LATERAL (
    SELECT
        c.name,
        c.geom
    FROM
        company AS c
    WHERE
        c.id <> e.company_id
    ORDER BY
        e.geom <-> c.geom, c.id -- **قاطع التعادل هنا**
    OFFSET 1
    LIMIT 1
) AS nearest2
CROSS JOIN LATERAL (
    SELECT
        c.name,
        c.geom
    FROM
        company AS c
    WHERE
        c.id <> e.company_id
    ORDER BY
        e.geom <-> c.geom, c.id -- **قاطع التعادل هنا**
    OFFSET 2
    LIMIT 1
) AS nearest3;