# Resultados de las consultas – Blockbuster Reborn

Resultados obtenidos al ejecutar 1_esquema_y_datos.sql y luego 2_consultas.sql en **MySQL 8.0.46** (cliente de línea de comandos mysql).

---

## Datos de prueba cargados

Antes de ver los reportes, este es un resumen de los casos especiales que se insertaron a propósito para probar cada JOIN:

| Caso pedido en el enunciado | Registro que lo cumple |
|---|---|
| Cliente que nunca ha rentado | `clientes.idCliente = 3` → Sofía Herrera |
| Película que nunca ha sido rentada | `peliculas.idPelicula = 4` → El Padrino |
| Empleado sin rentas procesadas | `empleados.idEmpleado = 3` → Andrés Torres |
| Renta "express" (sin cliente) | `rentas.idRenta = 3` → `idCliente = NULL` |
| Renta de "kiosko" (sin empleado) | `rentas.idRenta = 4` → `idEmpleado = NULL` |
| Renta con más de una película | `rentas.idRenta = 1` → detalles 1 (Matrix) y 2 (Gladiador) |
| Detalle con película inválida (extra) | `detallesRenta.idDetalle = 6` → `idPelicula = NULL` |

---

## Reporte 1: El ticket de compra completo (INNER JOIN)

```
+------------+----------------+-----------+------------------+
| fechaRenta | nombreCompleto | titulo    | nombreGenero     |
+------------+----------------+-----------+------------------+
| 2026-09-01 | Ana Martínez   | Gladiador | Acción           |
| 2026-09-01 | Ana Martínez   | Matrix    | Ciencia Ficción  |
| 2026-09-03 | Juan Pérez     | Toy Story | Comedia          |
| 2026-09-07 | Ana Martínez   | Gladiador | Acción           |
+------------+----------------+-----------+------------------+
4 rows in set
```

**Análisis:** solo aparecen las rentas "perfectas". No aparece la renta 3 (express, sin cliente) ni el detalle 6 (película NULL), porque el `INNER JOIN` descarta las filas que no encuentran pareja.

---

## Reporte 2: Seguimiento de Clientes (LEFT JOIN)

```
+----------------+---------+
| nombreCompleto | idRenta |
+----------------+---------+
| Ana Martínez   |       1 |
| Ana Martínez   |       4 |
| Juan Pérez     |       2 |
| Sofía Herrera  |    NULL |
+----------------+---------+
4 rows in set
```

**Análisis:** aparecen los 3 clientes. Sofía Herrera no ha rentado, por eso su `idRenta` es `NULL`. La renta express (3) no aparece porque no pertenece a ningún cliente.

---

## Reporte 3: Auditoría del Catálogo (RIGHT JOIN)

```
+------------------+-----------+
| titulo           | idDetalle |
+------------------+-----------+
| El Padrino       |      NULL |
| Gladiador        |         2 |
| Gladiador        |         5 |
| Matrix           |         1 |
| Toy Story        |         3 |
| Volver al Futuro |         4 |
+------------------+-----------+
6 rows in set
```

**Análisis:** aparecen las 5 películas del catálogo. *El Padrino* nunca se ha rentado, por eso su `idDetalle` es `NULL` (película "estancada en el estante"). *Gladiador* es la más rentada (2 veces).

---

## Reporte 4: Rendimiento total (FULL OUTER JOIN emulado con UNION)

```
+-----------------+---------+
| nombreEmpleado  | idRenta |
+-----------------+---------+
| NULL            |       4 |
| Andrés Torres   |    NULL |
| Carlos Ramírez  |       1 |
| Carlos Ramírez  |       3 |
| Laura Gómez     |       2 |
+-----------------+---------+
5 rows in set
```

**Análisis:**
- `NULL | 4` → la renta 4 se hizo en un kiosko, no la procesó ningún empleado (viene del `RIGHT JOIN`).
- `Andrés Torres | NULL` → empleado sin ventas (viene del `LEFT JOIN`).
- El resto son coincidencias normales, que aparecen en ambas consultas pero `UNION` elimina los duplicados.
