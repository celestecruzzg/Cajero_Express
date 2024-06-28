CREATE DATABASE cajero_express;
USE cajero_express;

--------------------------------------------------------------------------------------------------------
-- CREACIÓN DE LAS TABLAS

/* CREACIÓN DE LA TABLA CLIENTES */
CREATE TABLE tb_clientes(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25),
    ap_paterno VARCHAR(25),
    ap_materno VARCHAR(25),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Inactivo'
);


/* CREACIÓN DE LA TABLA DE TARJETAS */
CREATE TABLE tb_tarjetas (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    n_tarjeta VARCHAR(16),
    nip VARCHAR(4),
    saldo DECIMAL(20, 2),
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id_cliente)
);

/* CREACIÓN DE LA TABLA TIPO MOVIMIENTOS */
CREATE TABLE tb_tipo_movimientos (
    id_tipo_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50)
);

/* CREACIÓN DE LA TABLA MOVIMIENTOS */
CREATE TABLE tb_movimientos (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    monto DECIMAL(7, 2),
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_tarjeta INT,
    id_tipo_movimiento INT,
    FOREIGN KEY (id_tarjeta) REFERENCES tb_tarjetas(id_tarjeta),
    FOREIGN KEY (id_tipo_movimiento) REFERENCES tb_tipo_movimientos(id_tipo_movimiento)
);

--------------------------------------------------------------------------------------------------------
-- CREACIÓN DE LAS TABLAS PARA LOS TRIGGERS

/* CREACIÓN DE LA TABLA LOG CLIENTES */
CREATE TABLE tb_log_clientes (
    id_log_cliente INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(10),
    id_cliente INT,
    nombre_completo VARCHAR(250),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* CREACIÓN DE LA TABLA LOG TARJETAS */
CREATE TABLE tb_log_tarjetas (
    id_log_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(10),
    id_tarjeta INT,
    n_tarjeta VARCHAR(16),
    saldo DECIMAL(20, 2),
    id_cliente INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* CREACIÓN DE LA TABLA LOG TIPO MOVIMIENTOS */
CREATE TABLE tb_log_tipo_movimientos (
    id_log_tipo_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(10),
    id_tipo_movimiento INT,
    tipo VARCHAR(50),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


















TIPOS DE DATOS PARA FECHAS Y HORA
PARA FORMULARIO
DATE 1990-09-25
TIME 10:05:25
DATETIME 1990-09-25 10:05:25 <- inserta la fecha y hora del servidor
YEAR 1990
------------------------------------
DATOS AUTOMATICOS
TIMESTAMP CURRENT_TIMESTAMP -> fecha y hora actual de acuerdo a la zona de horario de registro


