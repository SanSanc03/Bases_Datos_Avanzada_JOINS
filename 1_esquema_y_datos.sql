-- =====================================================================
--  Proyecto: Blockbuster Reborn
--  Asignatura: Bases de Datos Avanzadas
--  Archivo: 1_esquema_y_datos.sql
--  Descripción: Creación de la base de datos (DDL), de las 7 tablas del
--               modelo y la inserción de los datos de prueba (DML).
--  Motor: MySQL 8.0
-- =====================================================================


-- =====================================================================
--  PARTE 1: MODELO ENTIDAD-RELACIÓN (DDL)
-- =====================================================================

-- Si la base de datos ya existe la borramos, así el script se puede
-- ejecutar varias veces sin errores y siempre queda desde cero.
DROP DATABASE IF EXISTS blockbusterReborn;

-- Creamos la base de datos con utf8mb4 para soportar tildes y la ñ.
CREATE DATABASE blockbusterReborn
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

-- Le indicamos a MySQL que vamos a trabajar sobre esta base de datos.
USE blockbusterReborn;


-- ---------------------------------------------------------------------
-- Tabla: sucursales
-- Guarda las tiendas físicas de la cadena.
-- ---------------------------------------------------------------------
CREATE TABLE sucursales (
    idSucursal      INT          NOT NULL AUTO_INCREMENT,
    nombreSucursal  VARCHAR(100) NOT NULL,
    PRIMARY KEY (idSucursal)
);


-- ---------------------------------------------------------------------
-- Tabla: empleados
-- Cada empleado trabaja en una sucursal (relación 1 a muchos).
-- ---------------------------------------------------------------------
CREATE TABLE empleados (
    idEmpleado      INT          NOT NULL AUTO_INCREMENT,
    nombreEmpleado  VARCHAR(100) NOT NULL,
    idSucursal      INT          NOT NULL,
    PRIMARY KEY (idEmpleado),
    CONSTRAINT fkEmpleadosSucursales
        FOREIGN KEY (idSucursal) REFERENCES sucursales (idSucursal)
);


-- ---------------------------------------------------------------------
-- Tabla: clientes
-- Clientes registrados que acumulan puntos.
-- ---------------------------------------------------------------------
CREATE TABLE clientes (
    idCliente          INT          NOT NULL AUTO_INCREMENT,
    nombreCompleto     VARCHAR(150) NOT NULL,
    correoElectronico  VARCHAR(150) NOT NULL,
    PRIMARY KEY (idCliente)
);


-- ---------------------------------------------------------------------
-- Tabla: generos
-- Categorías de las películas (Acción, Drama, etc.).
-- ---------------------------------------------------------------------
CREATE TABLE generos (
    idGenero      INT         NOT NULL AUTO_INCREMENT,
    nombreGenero  VARCHAR(50) NOT NULL,
    PRIMARY KEY (idGenero)
);


-- ---------------------------------------------------------------------
-- Tabla: peliculas
-- Catálogo de películas. Cada película pertenece a un género.
-- ---------------------------------------------------------------------
CREATE TABLE peliculas (
    idPelicula   INT          NOT NULL AUTO_INCREMENT,
    titulo       VARCHAR(150) NOT NULL,
    anioEstreno  INT          NOT NULL,
    idGenero     INT          NOT NULL,
    PRIMARY KEY (idPelicula),
    CONSTRAINT fkPeliculasGeneros
        FOREIGN KEY (idGenero) REFERENCES generos (idGenero)
);


-- ---------------------------------------------------------------------
-- Tabla: rentas
-- Encabezado de cada renta.
--   idCliente  puede ser NULL -> renta "express" (sin cliente registrado)
--   idEmpleado puede ser NULL -> renta hecha en un "kiosko" automático
-- ---------------------------------------------------------------------
CREATE TABLE rentas (
    idRenta     INT  NOT NULL AUTO_INCREMENT,
    fechaRenta  DATE NOT NULL,
    idCliente   INT  NULL,
    idEmpleado  INT  NULL,
    PRIMARY KEY (idRenta),
    CONSTRAINT fkRentasClientes
        FOREIGN KEY (idCliente) REFERENCES clientes (idCliente),
    CONSTRAINT fkRentasEmpleados
        FOREIGN KEY (idEmpleado) REFERENCES empleados (idEmpleado)
);


-- ---------------------------------------------------------------------
-- Tabla: detallesRenta
-- Tabla intermedia entre rentas y peliculas (una renta puede incluir
-- varias películas).
--   idPelicula puede ser NULL -> por ejemplo una película que se
--   registró mal o fue retirada del catálogo.
-- ---------------------------------------------------------------------
CREATE TABLE detallesRenta (
    idDetalle   INT NOT NULL AUTO_INCREMENT,
    idRenta     INT NOT NULL,
    idPelicula  INT NULL,
    PRIMARY KEY (idDetalle),
    CONSTRAINT fkDetallesRentas
        FOREIGN KEY (idRenta) REFERENCES rentas (idRenta),
    CONSTRAINT fkDetallesPeliculas
        FOREIGN KEY (idPelicula) REFERENCES peliculas (idPelicula)
);


-- =====================================================================
--  PARTE 2: INSERCIÓN DE DATOS (DML)
--  Se insertan primero las tablas "padre" y luego las "hijas" para no
--  violar las llaves foráneas.
-- =====================================================================

-- Sucursales (2 registros)
INSERT INTO sucursales (idSucursal, nombreSucursal) VALUES
    (1, 'Sucursal Chapinero'),
    (2, 'Sucursal Usaquén');

-- Empleados (3 registros)
-- Condición: Andrés Torres (id 3) NO procesa ninguna renta.
INSERT INTO empleados (idEmpleado, nombreEmpleado, idSucursal) VALUES
    (1, 'Carlos Ramírez', 1),
    (2, 'Laura Gómez',    1),
    (3, 'Andrés Torres',  2);

-- Clientes (3 registros)
-- Condición: Sofía Herrera (id 3) NUNCA ha rentado.
INSERT INTO clientes (idCliente, nombreCompleto, correoElectronico) VALUES
    (1, 'Ana Martínez',  'ana.martinez@correo.com'),
    (2, 'Juan Pérez',    'juan.perez@correo.com'),
    (3, 'Sofía Herrera', 'sofia.herrera@correo.com');

-- Géneros (4 registros)
INSERT INTO generos (idGenero, nombreGenero) VALUES
    (1, 'Acción'),
    (2, 'Comedia'),
    (3, 'Drama'),
    (4, 'Ciencia Ficción');

-- Películas (5 registros)
-- Condición: El Padrino (id 4) NUNCA ha sido rentada.
INSERT INTO peliculas (idPelicula, titulo, anioEstreno, idGenero) VALUES
    (1, 'Matrix',           1999, 4),
    (2, 'Gladiador',        2000, 1),
    (3, 'Toy Story',        1995, 2),
    (4, 'El Padrino',       1972, 3),
    (5, 'Volver al Futuro', 1985, 4);

-- Rentas (4 registros)
--   Renta 1: cliente Ana,  atendida por Carlos  -> renta normal
--   Renta 2: cliente Juan, atendida por Laura   -> renta normal
--   Renta 3: SIN cliente,  atendida por Carlos  -> renta "express"
--   Renta 4: cliente Ana,  SIN empleado         -> renta de "kiosko"
INSERT INTO rentas (idRenta, fechaRenta, idCliente, idEmpleado) VALUES
    (1, '2026-09-01', 1,    1),
    (2, '2026-09-03', 2,    2),
    (3, '2026-09-05', NULL, 1),
    (4, '2026-09-07', 1,    NULL);

-- Detalles de renta (6 registros)
--   La renta 1 incluye DOS películas (Matrix y Gladiador).
--   La renta 4 incluye Gladiador y un detalle con película NULL
--   (película inválida), útil para probar el INNER JOIN del reporte 1.
INSERT INTO detallesRenta (idDetalle, idRenta, idPelicula) VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 3, 5),
    (5, 4, 2),
    (6, 4, NULL);
