
USE blockbusterReborn;
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


SELECT
    c.nombreCompleto,
    r.idRenta
FROM clientes c
LEFT JOIN rentas r ON c.idCliente = r.idCliente
ORDER BY c.nombreCompleto, r.idRenta;

SELECT
    p.titulo,
    dr.idDetalle
FROM detallesRenta dr
RIGHT JOIN peliculas p ON dr.idPelicula = p.idPelicula
ORDER BY p.titulo, dr.idDetalle;


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
