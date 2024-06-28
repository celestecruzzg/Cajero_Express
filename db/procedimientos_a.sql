-- Procedimiento para login
DELIMITER //

CREATE PROCEDURE sp_login (
    IN p_n_tarjeta VARCHAR(16),
    IN p_nip VARCHAR(4)
)
BEGIN
    SELECT id_tarjeta, n_tarjeta, nip, saldo, tb_tarjetas.id_cliente, nombre, ap_paterno, ap_materno, estado
    FROM tb_tarjetas
    INNER JOIN tb_clientes ON tb_tarjetas.id_cliente = tb_clientes.id_cliente
    WHERE n_tarjeta = p_n_tarjeta AND nip = p_nip;
END //

DELIMITER ;


-- Procedimiento para estado inactivo
DELIMITER //

CREATE PROCEDURE sp_estado_inactivo (
    IN p_id_cliente INT
)
BEGIN
    UPDATE tb_clientes
    SET estado = 'Inactivo'
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;


-- Procedimiento para estado activo
DELIMITER //

CREATE PROCEDURE sp_estado_activo (
    IN p_id_cliente INT
)
BEGIN
    UPDATE tb_clientes
    SET estado = 'Activo'
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;


-- Procedimiento para consulta retiro
DELIMITER //

CREATE PROCEDURE sp_consulta_retiro (
    IN n_tarjeta VARCHAR(16),
    IN saldo DECIMAL(20, 2)
)
BEGIN
    SELECT id_tarjeta, n_tarjeta, saldo
    FROM tb_tarjetas
    WHERE n_tarjeta = n_tarjeta AND saldo = saldo;
END //

DELIMITER ;


-- Procedimiento para actualización retiro
DELIMITER //

CREATE PROCEDURE sp_actualiza_retiro (
    IN id_tarjeta INT,
    IN saldo_nuevo DECIMAL(20, 2)
)
BEGIN
    UPDATE tb_tarjetas
    SET saldo = saldo_nuevo
    WHERE id_tarjeta = id_tarjeta;
END //

DELIMITER ;
























/* Procedimiento para tb_clientes */
DELIMITER //

CREATE PROCEDURE sp_insertar_cliente (
    IN nombre VARCHAR(25),
    IN ap_paterno VARCHAR(25),
    IN ap_materno VARCHAR(25)
)
BEGIN
    INSERT INTO tb_clientes (nombre, ap_paterno, ap_materno)
    VALUES (nombre, ap_paterno, ap_materno);
END;

/* Procedimiento para tb_tarjetas */
DELIMITER //

CREATE PROCEDURE sp_insertar_tarjeta (
    IN n_tarjeta VARCHAR(16),
    IN nip VARCHAR(4),
    IN saldo DECIMAL(20,2),
    IN id_cliente INT
)
BEGIN
    INSERT INTO tb_tarjetas (n_tarjeta, nip, saldo, id_cliente)
    VALUES (n_tarjeta, nip, saldo, id_cliente);
END;


/* Procedimiento para tb_tipo_movimientos */
DELIMITER //

CREATE PROCEDURE sp_insertar_tipo_movimiento (
    IN tipo VARCHAR(50)
)
BEGIN
    INSERT INTO tb_tipo_movimientos (tipo)
    VALUES (tipo);
END;


/* Procedimiento para tb_movimientos */
DELIMITER //

CREATE PROCEDURE sp_insertar_movimiento (
    IN monto DECIMAL(7,2),
    IN id_tarjeta INT,
    IN id_tipo_movimiento INT
)
BEGIN
    INSERT INTO tb_movimientos (monto, id_tarjeta, id_tipo_movimientos)
    VALUES (monto, id_tarjeta, id_tipo_movimiento);
END;