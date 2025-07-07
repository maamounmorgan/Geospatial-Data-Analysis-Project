SELECT
    id AS id,
    name AS name,
    -- الإحداثيات المترية (EPSG:26918)
    ST_X(geom) AS m_x,
    ST_Y(geom) AS m_y,
    -- الإحداثيات الجغرافية (خط الطول وخط العرض - EPSG:4326)
    ST_X(ST_Transform(geom, 4326)) AS long,
    ST_Y(ST_Transform(geom, 4326)) AS lat
FROM
    company;