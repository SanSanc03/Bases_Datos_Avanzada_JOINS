DROP DATABASE IF EXISTS blockbusterReborn;
CREATE DATABASE blockbusterReborn
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
USE blockbusterReborn;



CREATE TABLE sucursales (
    idSucursal      INT          NOT NULL AUTO_INCREMENT,
    nombreSucursal  VARCHAR(100) NOT NULL,
    PRIMARY KEY (idSucursal)
);


CREATE TABLE empleados (
    idEmpleado      INT          NOT NULL AUTO_INCREMENT,
    nombreEmpleado  VARCHAR(100) NOT NULL,
    idSucursal      INT          NOT NULL,
    PRIMARY KEY (idEmpleado),
    CONSTRAINT fkEmpleadosSucursales
        FOREIGN KEY (idSucursal) REFERENCES sucursales (idSucursal)
);


CREATE TABLE clientes (
    idCliente          INT          NOT NULL AUTO_INCREMENT,
    nombreCompleto     VARCHAR(150) NOT NULL,
    correoElectronico  VARCHAR(150) NOT NULL,
    PRIMARY KEY (idCliente)
);


CREATE TABLE generos (
    idGenero      INT         NOT NULL AUTO_INCREMENT,
    nombreGenero  VARCHAR(50) NOT NULL,
    PRIMARY KEY (idGenero)
);


CREATE TABLE peliculas (
    idPelicula   INT          NOT NULL AUTO_INCREMENT,
    titulo       VARCHAR(150) NOT NULL,
    anioEstreno  INT          NOT NULL,
    idGenero     INT          NOT NULL,
    PRIMARY KEY (idPelicula),
    CONSTRAINT fkPeliculasGeneros
        FOREIGN KEY (idGenero) REFERENCES generos (idGenero)
);


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

INSERT INTO sucursales (idSucursal, nombreSucursal) VALUES
    (1, 'Sucursal Chapinero'),
    (2, 'Sucursal Usaquén');

INSERT INTO empleados (idEmpleado, nombreEmpleado, idSucursal) VALUES
    (1, 'Carlos Ramírez', 1),
    (2, 'Laura Gómez',    1),
    (3, 'Andrés Torres',  2);

INSERT INTO clientes (idCliente, nombreCompleto, correoElectronico) VALUES
    (1, 'Ana Martínez',  'ana.martinez@correo.com'),
    (2, 'Juan Pérez',    'juan.perez@correo.com'),
    (3, 'Sofía Herrera', 'sofia.herrera@correo.com');

INSERT INTO generos (idGenero, nombreGenero) VALUES
    (1, 'Acción'),
    (2, 'Comedia'),
    (3, 'Drama'),
    (4, 'Ciencia Ficción');

INSERT INTO peliculas (idPelicula, titulo, anioEstreno, idGenero) VALUES
    (1, 'Matrix',           1999, 4),
    (2, 'Gladiador',        2000, 1),
    (3, 'Toy Story',        1995, 2),
    (4, 'El Padrino',       1972, 3),
    (5, 'Volver al Futuro', 1985, 4);

INSERT INTO rentas (idRenta, fechaRenta, idCliente, idEmpleado) VALUES
    (1, '2026-09-01', 1,    1),
    (2, '2026-09-03', 2,    2),
    (3, '2026-09-05', NULL, 1),
    (4, '2026-09-07', 1,    NULL);

INSERT INTO detallesRenta (idDetalle, idRenta, idPelicula) VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 3, 5),
    (5, 4, 2),
    (6, 4, NULL);
