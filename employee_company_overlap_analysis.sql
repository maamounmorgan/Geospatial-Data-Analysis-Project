select * from employee
select * from company
select * from employee_company_overlap

CREATE VIEW employee_company_overlap AS
WITH
Radii AS (
    SELECT 500 AS radius, '500 meters' AS range_category UNION ALL
    SELECT 1000 AS radius, '1000 meters' AS range_category UNION ALL
    SELECT 2000 AS radius, '2000 meters' AS range_category UNION ALL
    SELECT 3000 AS radius, '3000 meters' AS range_category UNION ALL
    SELECT 4000 AS radius, '4000 meters' AS range_category UNION ALL
    SELECT 5000 AS radius, '5000 meters' AS range_category
),
CompanyBuffersWithRadii AS (
    SELECT
        c.id AS company_id,
        c.name AS company_name,
        c.geom AS company_geom,
        r.radius,
        r.range_category,
        ST_Buffer(c.geom, r.radius) AS buffer_geom
    FROM
        company AS c, Radii r
),
OverlappingBuffersAtSameRadius AS (
    SELECT
        cb1.company_id AS company_id_1,
        cb1.company_name AS company_name_1,
        cb1.company_geom AS company_geom_1,
        cb2.company_id AS company_id_2,
        cb2.company_name AS company_name_2,
        cb2.company_geom AS company_geom_2,
        cb1.radius AS overlap_radius_meters,
        cb1.range_category AS overlap_range_category,
        ST_Intersection(cb1.buffer_geom, cb2.buffer_geom) AS intersection_geom,
        -- تم التعديل هنا: قسمة على 1,000,000 لتحويلها إلى كيلومتر مربع
        (ST_Area(ST_Intersection(cb1.buffer_geom, cb2.buffer_geom)) / 1000000.0) AS intersection_area_sq_km
    FROM
        CompanyBuffersWithRadii cb1
    JOIN
        CompanyBuffersWithRadii cb2
        ON ST_Intersects(cb1.buffer_geom, cb2.buffer_geom)
        AND cb1.company_id < cb2.company_id
        AND cb1.radius = cb2.radius
    WHERE
        ST_Area(ST_Intersection(cb1.buffer_geom, cb2.buffer_geom)) > 0
)
SELECT
    e.id AS employee_id,
    ocb.company_id_1,
    ocb.company_name_1,
    ST_Distance(e.geom, ocb.company_geom_1) AS distance_to_company_1_meters,
    ocb.company_id_2,
    ocb.company_name_2,
    ST_Distance(e.geom, ocb.company_geom_2) AS distance_to_company_2_meters,
    ocb.overlap_radius_meters,
    ocb.overlap_range_category,
    ocb.intersection_area_sq_km, -- تم تغيير اسم العمود للإشارة إلى الكيلومتر المربع
    ST_AsText(ocb.intersection_geom) AS intersection_wkt_geometry
FROM
    employee AS e
JOIN
    OverlappingBuffersAtSameRadius AS ocb
    ON ST_Contains(ocb.intersection_geom, e.geom);