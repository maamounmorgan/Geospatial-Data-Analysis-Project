select * from boro





CREATE VIEW boro_junction_density AS

WITH

StreetIntersections AS (

    SELECT

        s1.id AS street_id_1,

        s2.id AS street_id_2,

        ST_Intersection(s1.geom, s2.geom) AS intersection_geom

    FROM

        str AS s1

    JOIN

        str AS s2

        ON ST_Intersects(s1.geom, s2.geom)

        AND s1.id < s2.id

),

JunctionPoints AS (

    SELECT DISTINCT (d.geom) AS junction_point_geom

    FROM StreetIntersections si,

         LATERAL ST_Dump(si.intersection_geom) AS d

    WHERE

        ST_GeometryType(d.geom) IN ('ST_Point', 'ST_MultiPoint')

)

SELECT

    b.boro_name AS boro_name,

    (ST_Area(b.geom) / 1000000.0) AS area_sq_km,

    COUNT(jp.junction_point_geom) AS total_junctions_count,

    (COUNT(jp.junction_point_geom) / (ST_Area(b.geom) / 1000000.0)) AS junction_density_per_sq_km

FROM

    boro AS b

JOIN

    JunctionPoints AS jp

    ON ST_Contains(b.geom, jp.junction_point_geom)

GROUP BY

    b.boro_name, b.geom

ORDER BY

    b.boro_name;