CREATE TABLE employee AS
WITH Employees AS (
    SELECT
        "Employee Number",
        "boro_id",
        ROW_NUMBER() OVER (PARTITION BY "boro_id" ORDER BY "Employee Number") as rn
    FROM
        "HRDATA"
),
RankedEmpLocations AS (
    SELECT
        x,
        y,
        geojson,
        wkt,
        geom,
        "boro_id",
        ROW_NUMBER() OVER (PARTITION BY "boro_id" ORDER BY random()) as rn
    FROM
        emp_loc
)
SELECT
    hr.*, -- جميع الأعمدة من HRDATA
    rel.x,
    rel.y,
    rel.geojson,
    rel.wkt,
    rel.geom
FROM
    "HRDATA" AS hr
JOIN
    Employees AS re ON hr."Employee Number" = re."Employee Number"
JOIN
    RankedEmpLocations AS rel ON re."boro_id" = rel."boro_id" AND re.rn = rel.rn;