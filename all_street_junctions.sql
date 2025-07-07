
CREATE VIEW all_street_junctions AS


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
JunctionPointsRaw AS (
    SELECT DISTINCT (d.geom) AS junction_point_geom
    FROM StreetIntersections si,
         LATERAL ST_Dump(si.intersection_geom) AS d
    WHERE
        ST_GeometryType(d.geom) IN ('ST_Point', 'ST_MultiPoint')
)
SELECT
    -- نُنشئ معرفًا فريدًا لكل نقطة تقاطع
    ROW_NUMBER() OVER () AS junction_id,
    jp.junction_point_geom AS geom -- هذا هو عمود الهندسة الذي ستستخدمه في QGIS
FROM
    JunctionPointsRaw AS jp;