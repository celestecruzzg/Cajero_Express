-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 28-06-2024 a las 14:51:04
-- Versión del servidor: 8.0.37-0ubuntu0.24.04.1
-- Versión de PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cajero_express`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`celeste`@`%` PROCEDURE `sp_actualiza_retiro` (IN `id_tarjeta` INT, IN `saldo_nuevo` DECIMAL(20,2))   BEGIN
    UPDATE tb_tarjetas
    SET saldo = saldo_nuevo
    WHERE id_tarjeta = id_tarjeta$$

CREATE DEFINER=`celeste`@`%` PROCEDURE `sp_consulta_retiro` (IN `n_tarjeta` VARCHAR(16), IN `saldo` DECIMAL(20,2))   BEGIN
    SELECT id_tarjeta, n_tarjeta, saldo
    FROM tb_tarjetas
    WHERE n_tarjeta = n_tarjeta AND saldo = saldo$$

CREATE DEFINER=`celeste`@`%` PROCEDURE `sp_estado_activo` (IN `id_cliente` INT)   BEGIN
    UPDATE tb_clientes
    SET estado = 'Activo'
    WHERE id_cliente = id_cliente$$

CREATE DEFINER=`celeste`@`%` PROCEDURE `sp_estado_inactivo` (IN `id_cliente` INT)   BEGIN
    UPDATE tb_clientes
    SET estado = 'Inactivo'
    WHERE id_cliente = id_cliente$$

CREATE DEFINER=`celeste`@`%` PROCEDURE `sp_login` (IN `p_n_tarjeta` VARCHAR(16), IN `p_nip` VARCHAR(4))   BEGIN
    SELECT id_tarjeta, n_tarjeta, nip, saldo, tb_tarjetas.id_cliente, nombre, ap_paterno, ap_materno, estado
    FROM tb_tarjetas
    INNER JOIN tb_clientes ON tb_tarjetas.id_cliente = tb_clientes.id_cliente
    WHERE n_tarjeta = p_n_tarjeta AND nip = p_nip$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_clientes`
--

CREATE TABLE `tb_clientes` (
  `id_cliente` int NOT NULL,
  `nombre` varchar(25) DEFAULT NULL,
  `ap_paterno` varchar(25) DEFAULT NULL,
  `ap_materno` varchar(25) DEFAULT NULL,
  `estado` enum('Activo','Inactivo') DEFAULT 'Inactivo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tb_clientes`
--

INSERT INTO `tb_clientes` (`id_cliente`, `nombre`, `ap_paterno`, `ap_materno`, `estado`) VALUES
(1, 'Celeste', 'González', 'Cruz', 'Inactivo');

--
-- Disparadores `tb_clientes`
--
DELIMITER $$
CREATE TRIGGER `tg_log_clientes_delete` BEFORE DELETE ON `tb_clientes` FOR EACH ROW BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES ('DELETE', OLD.id_cliente, 
    CONCAT(
        OLD.nombre, ' ', 
        OLD.ap_paterno, ' ', 
        OLD.ap_materno
        )
    )$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_log_clientes_insert` AFTER INSERT ON `tb_clientes` FOR EACH ROW BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES ('INSERT', NEW.id_cliente, 
    CONCAT(
        NEW.nombre, ' ', 
        NEW.ap_paterno, ' ', 
        NEW.ap_materno
        )
    )$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_log_clientes_update` AFTER UPDATE ON `tb_clientes` FOR EACH ROW BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES (
        'UPDATE', OLD.id_cliente,
        CONCAT(
            'OLD: ', OLD.nombre, ' NEW: ', NEW.nombre, ' ',
            'OLD: ', OLD.ap_paterno, ' NEW: ', NEW.ap_paterno, ' ',
            'OLD: ', OLD.ap_materno, ' NEW: ', NEW.ap_materno
        )
    )$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_login_cliente` AFTER UPDATE ON `tb_clientes` FOR EACH ROW BEGIN
    IF NEW.estado = 'Activo' AND OLD.estado <> 'Activo' THEN
        INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
        VALUES ('LOGIN', NEW.id_cliente, CONCAT(NEW.nombre, ' ', NEW.ap_paterno, ' ', NEW.ap_materno))$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_logout_cliente` AFTER UPDATE ON `tb_clientes` FOR EACH ROW BEGIN
    IF NEW.estado = 'Inactivo' AND OLD.estado <> 'Inactivo' THEN
        INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
        VALUES ('LOGOUT', OLD.id_cliente, CONCAT(OLD.nombre, ' ', OLD.ap_paterno, ' ', OLD.ap_materno))$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_log_clientes`
--

CREATE TABLE `tb_log_clientes` (
  `id_log_cliente` int NOT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `nombre_completo` varchar(250) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tb_log_clientes`
--

INSERT INTO `tb_log_clientes` (`id_log_cliente`, `accion`, `id_cliente`, `nombre_completo`, `fecha`) VALUES
(1, 'INSERT', 1, 'Celeste González Cruz', '2024-06-28 13:33:45'),
(2, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 13:39:27'),
(3, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 13:39:27'),
(4, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 13:41:50'),
(5, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 13:41:50'),
(6, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 13:44:49'),
(7, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 13:44:49'),
(8, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 13:45:29'),
(9, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 13:45:29'),
(10, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 13:45:54'),
(11, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 13:45:54'),
(12, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:00:49'),
(13, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:00:49'),
(14, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:11:53'),
(15, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:11:53'),
(16, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:12:02'),
(17, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:12:02'),
(18, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:23:48'),
(19, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:23:48'),
(20, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:29:57'),
(21, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:29:57'),
(22, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:31:28'),
(23, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:34:35'),
(24, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:34:35'),
(25, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:35:26'),
(26, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:35:26'),
(27, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:45:38'),
(28, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:45:38'),
(29, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:45:53'),
(30, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:45:53'),
(31, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:46:22'),
(32, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:46:22'),
(33, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:46:34'),
(34, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:46:34'),
(35, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:47:07'),
(36, 'LOGIN', 1, 'Celeste González Cruz', '2024-06-28 14:47:07'),
(37, 'UPDATE', 1, 'OLD: Celeste NEW: Celeste OLD: González NEW: González OLD: Cruz NEW: Cruz', '2024-06-28 14:47:21'),
(38, 'LOGOUT', 1, 'Celeste González Cruz', '2024-06-28 14:47:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_log_tarjetas`
--

CREATE TABLE `tb_log_tarjetas` (
  `id_log_tarjeta` int NOT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `id_tarjeta` int DEFAULT NULL,
  `n_tarjeta` varchar(16) DEFAULT NULL,
  `saldo` decimal(20,2) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tb_log_tarjetas`
--

INSERT INTO `tb_log_tarjetas` (`id_log_tarjeta`, `accion`, `id_tarjeta`, `n_tarjeta`, `saldo`, `id_cliente`, `fecha`) VALUES
(1, 'INSERT', 1, '4152313720040612', 50000.00, 1, '2024-06-28 13:33:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_log_tipo_movimientos`
--

CREATE TABLE `tb_log_tipo_movimientos` (
  `id_log_tipo_movimiento` int NOT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `id_tipo_movimiento` int DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_movimientos`
--

CREATE TABLE `tb_movimientos` (
  `id_movimiento` int NOT NULL,
  `monto` decimal(7,2) DEFAULT NULL,
  `fecha_movimiento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_tarjeta` int DEFAULT NULL,
  `id_tipo_movimiento` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tarjetas`
--

CREATE TABLE `tb_tarjetas` (
  `id_tarjeta` int NOT NULL,
  `n_tarjeta` varchar(16) DEFAULT NULL,
  `nip` varchar(4) DEFAULT NULL,
  `saldo` decimal(20,2) DEFAULT NULL,
  `id_cliente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tb_tarjetas`
--

INSERT INTO `tb_tarjetas` (`id_tarjeta`, `n_tarjeta`, `nip`, `saldo`, `id_cliente`) VALUES
(1, '4152313720040612', '0612', 50000.00, 1);

--
-- Disparadores `tb_tarjetas`
--
DELIMITER $$
CREATE TRIGGER `tb_log_tarjetas_delete` AFTER DELETE ON `tb_tarjetas` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('DELETE', OLD.id_tarjeta, OLD.n_tarjeta, OLD.saldo, OLD.id_cliente)$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tb_log_tarjetas_insert` AFTER INSERT ON `tb_tarjetas` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('INSERT', NEW.id_tarjeta, NEW.n_tarjeta, NEW.saldo, NEW.id_cliente)$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tb_log_tarjetas_update` AFTER UPDATE ON `tb_tarjetas` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('UPDATE', NEW.id_tarjeta, NEW.n_tarjeta, NEW.saldo, NEW.id_cliente)$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_consulta` BEFORE UPDATE ON `tb_tarjetas` FOR EACH ROW BEGIN
    DECLARE consulta_id INT$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_retiro` BEFORE UPDATE ON `tb_tarjetas` FOR EACH ROW BEGIN

    DECLARE v_saldo DECIMAL(20,2)$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipo_movimientos`
--

CREATE TABLE `tb_tipo_movimientos` (
  `id_tipo_movimiento` int NOT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Disparadores `tb_tipo_movimientos`
--
DELIMITER $$
CREATE TRIGGER `tb_log_tipo_movimientos_delete` AFTER DELETE ON `tb_tipo_movimientos` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('DELETE', OLD.id_tipo_movimiento, OLD.tipo)$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tb_log_tipo_movimientos_insert` AFTER INSERT ON `tb_tipo_movimientos` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('INSERT', NEW.id_tipo_movimiento, NEW.tipo)$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tb_log_tipo_movimientos_update` AFTER UPDATE ON `tb_tipo_movimientos` FOR EACH ROW BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('UPDATE', NEW.id_tipo_movimiento, NEW.tipo)$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tb_clientes`
--
ALTER TABLE `tb_clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `tb_log_clientes`
--
ALTER TABLE `tb_log_clientes`
  ADD PRIMARY KEY (`id_log_cliente`);

--
-- Indices de la tabla `tb_log_tarjetas`
--
ALTER TABLE `tb_log_tarjetas`
  ADD PRIMARY KEY (`id_log_tarjeta`);

--
-- Indices de la tabla `tb_log_tipo_movimientos`
--
ALTER TABLE `tb_log_tipo_movimientos`
  ADD PRIMARY KEY (`id_log_tipo_movimiento`);

--
-- Indices de la tabla `tb_movimientos`
--
ALTER TABLE `tb_movimientos`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_tarjeta` (`id_tarjeta`),
  ADD KEY `id_tipo_movimiento` (`id_tipo_movimiento`);

--
-- Indices de la tabla `tb_tarjetas`
--
ALTER TABLE `tb_tarjetas`
  ADD PRIMARY KEY (`id_tarjeta`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `tb_tipo_movimientos`
--
ALTER TABLE `tb_tipo_movimientos`
  ADD PRIMARY KEY (`id_tipo_movimiento`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tb_clientes`
--
ALTER TABLE `tb_clientes`
  MODIFY `id_cliente` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tb_log_clientes`
--
ALTER TABLE `tb_log_clientes`
  MODIFY `id_log_cliente` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `tb_log_tarjetas`
--
ALTER TABLE `tb_log_tarjetas`
  MODIFY `id_log_tarjeta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tb_log_tipo_movimientos`
--
ALTER TABLE `tb_log_tipo_movimientos`
  MODIFY `id_log_tipo_movimiento` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tb_movimientos`
--
ALTER TABLE `tb_movimientos`
  MODIFY `id_movimiento` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tb_tarjetas`
--
ALTER TABLE `tb_tarjetas`
  MODIFY `id_tarjeta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tb_tipo_movimientos`
--
ALTER TABLE `tb_tipo_movimientos`
  MODIFY `id_tipo_movimiento` int NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tb_movimientos`
--
ALTER TABLE `tb_movimientos`
  ADD CONSTRAINT `tb_movimientos_ibfk_1` FOREIGN KEY (`id_tarjeta`) REFERENCES `tb_tarjetas` (`id_tarjeta`),
  ADD CONSTRAINT `tb_movimientos_ibfk_2` FOREIGN KEY (`id_tipo_movimiento`) REFERENCES `tb_tipo_movimientos` (`id_tipo_movimiento`);

--
-- Filtros para la tabla `tb_tarjetas`
--
ALTER TABLE `tb_tarjetas`
  ADD CONSTRAINT `tb_tarjetas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `tb_clientes` (`id_cliente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
