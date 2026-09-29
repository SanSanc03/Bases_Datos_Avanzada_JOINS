-- =====================================================================
--  Proyecto: Blockbuster Reborn
--  Archivo: 2_consultas.sql
--  Descripción: Consultas de negocio (DQL) usando los diferentes tipos
--               de JOIN.
--  Motor: MySQL 8.0
-- =====================================================================

USE blockbusterReborn;


-- =====================================================================
-- REPORTE 1: El ticket de compra completo  (INNER JOIN)
-- ---------------------------------------------------------------------
-- Se muestran solo las rentas "perfectas": las que tienen un cliente
-- registrado y una película válida en el detalle. El INNER JOIN deja
-- por fuera automáticamente las filas donde idCliente o idPelicula son
-- NULL, porque no encuentran pareja en la otra tabla.
-- =====================================================================
SELECT
    r.fechaRenta,
    c.nombreCompleto,
    p.titulo,
    g.nombreGenero
FROM rentas r
INNER JOIN clientes c       ON r.idCliente   = c.idCliente
INNER JOIN detallesRenta dr ON r.idRenta     = dr.idRenta
INNER JOIN peliculas p      ON dr.idPelicula = p.idPelicula
INNER JOIN generos g        ON p.idGenero    = g.idGenero
ORDER BY r.fechaRenta, p.titulo;


-- =====================================================================
-- REPORTE 2: Seguimiento de Clientes  (LEFT JOIN)
-- ---------------------------------------------------------------------
-- Deben aparecer TODOS los clientes. La tabla clientes va a la
-- izquierda, así que el LEFT JOIN la conserva completa. Si un cliente
-- no tiene rentas, idRenta sale como NULL.
-- =====================================================================
SELECT
    c.nombreCompleto,
    r.idRenta
FROM clientes c
LEFT JOIN rentas r ON c.idCliente = r.idCliente
ORDER BY c.nombreCompleto, r.idRenta;


-- =====================================================================
-- REPORTE 3: Auditoría del Catálogo  (RIGHT JOIN)
-- ---------------------------------------------------------------------
-- Deben aparecer TODAS las películas. Como se pide RIGHT JOIN, la tabla
-- peliculas se coloca a la derecha. Las películas que nunca se han
-- rentado muestran idDetalle en NULL.
-- =====================================================================
SELECT
    p.titulo,
    dr.idDetalle
FROM detallesRenta dr
RIGHT JOIN peliculas p ON dr.idPelicula = p.idPelicula
ORDER BY p.titulo, dr.idDetalle;


-- =====================================================================
-- REPORTE 4: Rendimiento total  (FULL OUTER JOIN emulado con UNION)
-- ---------------------------------------------------------------------
-- MySQL no tiene FULL OUTER JOIN, así que se emula así:
--   1) LEFT JOIN  -> todos los empleados (incluye los que no tienen
--                    rentas, con idRenta en NULL).
--   2) RIGHT JOIN -> todas las rentas (incluye las de kiosko, con
--                    nombreEmpleado en NULL).
--   3) UNION junta ambos resultados y elimina las filas repetidas.
-- =====================================================================
SELECT
    e.nombreEmpleado,
    r.idRenta
FROM empleados e
LEFT JOIN rentas r ON e.idEmpleado = r.idEmpleado

UNION

SELECT
    e.nombreEmpleado,
    r.idRenta
FROM empleados e
RIGHT JOIN rentas r ON e.idEmpleado = r.idEmpleado

ORDER BY nombreEmpleado, idRenta;
