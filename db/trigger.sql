-- TRIGGER PARA CLIENTES


-- TRIGGER LOG CLIENTES INSERT
DELIMITER //
CREATE TRIGGER tg_log_clientes_insert
AFTER INSERT ON tb_clientes 
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES ('INSERT', NEW.id_cliente, 
    CONCAT(
        NEW.nombre, ' ', 
        NEW.ap_paterno, ' ', 
        NEW.ap_materno
        )
    );
END;
//

-- TRIGGER LOG CLIENTES UPDATE
DELIMITER //
CREATE TRIGGER tg_log_clientes_update
AFTER UPDATE ON tb_clientes 
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES (
        'UPDATE', OLD.id_cliente,
        CONCAT(
            'OLD: ', OLD.nombre, ' NEW: ', NEW.nombre, ' ',
            'OLD: ', OLD.ap_paterno, ' NEW: ', NEW.ap_paterno, ' ',
            'OLD: ', OLD.ap_materno, ' NEW: ', NEW.ap_materno
        )
    );
END;
//

-- TRIGGER LOG CLIENTES DELETE
DELIMITER //
CREATE TRIGGER tg_log_clientes_delete
BEFORE DELETE ON tb_clientes
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
    VALUES ('DELETE', OLD.id_cliente, 
    CONCAT(
        OLD.nombre, ' ', 
        OLD.ap_paterno, ' ', 
        OLD.ap_materno
        )
    );
END;
//


----------------------------------------------------------------------------------------------------
-- TRIGGER PARA TARJETAS


-- TRIGGER LOG TARJETAS INSERT
DELIMITER //
CREATE TRIGGER tb_log_tarjetas_insert
AFTER INSERT ON tb_tarjetas 
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('INSERT', NEW.id_tarjeta, NEW.n_tarjeta, NEW.saldo, NEW.id_cliente);
END;
//

-- TRIGGER LOG TARJETAS UPDATE
DELIMITER //
CREATE TRIGGER tb_log_tarjetas_update
AFTER UPDATE ON tb_tarjetas
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('UPDATE', NEW.id_tarjeta, NEW.n_tarjeta, NEW.saldo, NEW.id_cliente);
END;
//

-- TRIGGER LOG TARJETAS DELETE
DELIMITER //
CREATE TRIGGER tb_log_tarjetas_delete
AFTER DELETE ON tb_tarjetas
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tarjetas (accion, id_tarjeta, n_tarjeta, saldo, id_cliente)
    VALUES ('DELETE', OLD.id_tarjeta, OLD.n_tarjeta, OLD.saldo, OLD.id_cliente);
END;
//


-----------------------------------------------------------------------------------------------------
-- TRIGGER PARA TIPO MOVIMIENTOS


-- TRIGGER LOG TIPO MOVIMIENTOS INSERT
DELIMITER //
CREATE TRIGGER tb_log_tipo_movimientos_insert
AFTER INSERT ON tb_tipo_movimientos 
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('INSERT', NEW.id_tipo_movimiento, NEW.tipo);
END;
//

-- TRIGGER LOG TIPO MOVIMIENTOS UPDATE
DELIMITER //
CREATE TRIGGER tb_log_tipo_movimientos_update
AFTER UPDATE ON tb_tipo_movimientos
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('UPDATE', NEW.id_tipo_movimiento, NEW.tipo);
END;
//

-- TRIGGER LOG TIPO MOVIMIENTOS DELETE
DELIMITER //
CREATE TRIGGER tb_log_tipo_movimientos_delete
AFTER DELETE ON tb_tipo_movimientos
FOR EACH ROW 
BEGIN
    INSERT INTO tb_log_tipo_movimientos (accion, id_tipo_movimiento, tipo)
    VALUES ('DELETE', OLD.id_tipo_movimiento, OLD.tipo);
END;
//


-------------------------------------------------------------------------------------------------------
-- TRIGGER PARA LOGIN Y LOGOUT


-- TRIGGER PARA LOGIN
DELIMITER //
CREATE TRIGGER tg_login_cliente
AFTER UPDATE ON tb_clientes 
FOR EACH ROW 
BEGIN
    IF NEW.estado = 'activo' AND OLD.estado <> 'activo' THEN
        INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
        VALUES ('LOGIN', NEW.id_cliente, CONCAT(NEW.nombre, ' ', NEW.ap_paterno, ' ', NEW.ap_materno));
    END IF;
END;
//

-- TRIGGER PARA LOGOUT
DELIMITER // 
CREATE TRIGGER tg_logout_cliente
AFTER UPDATE ON tb_clientes 
FOR EACH ROW 
BEGIN
    IF NEW.estado = 'inactivo' AND OLD.estado <> 'inactivo' THEN
        INSERT INTO tb_log_clientes (accion, id_cliente, nombre_completo)
        VALUES ('LOGOUT', OLD.id_cliente, CONCAT(OLD.nombre, ' ', OLD.ap_paterno, ' ', OLD.ap_materno));
    END IF;
END;
//


--------------------------------------------------------------------------------------------------------
-- TRIGGER PARA RETIRO


DELIMITER //

CREATE TRIGGER tg_retiro
BEFORE UPDATE ON tb_tarjetas
FOR EACH ROW
BEGIN

    DECLARE v_saldo DECIMAL(20,2);
    DECLARE v_monto DECIMAL(20,2);
    DECLARE retiro_id INT;

    -- Consulta el id_tipo_movimiento
    SELECT id_tipo_movimiento INTO retiro_id
    FROM tb_tipo_movimientos
    WHERE tipo = 'retiro';

    SET v_saldo = OLD.saldo;
    SET v_monto = NEW.saldo - OLD.saldo;

    IF v_monto < 0 THEN
    -- cuando se resta el saldo acutal con el viejo, el valor es negativo (invertirmos los signos)
        SET v_monto = -v_monto;
            IF v_saldo >= v_monto THEN
                INSERT INTO tb_movimientos (monto,id_tarjeta,id_tipo_movimiento)
                VALUE (v_monto,OLD.id_tarjeta,retiro_id);

                -- Actualizar el saldo tb_tarjetas
                SET NEW.saldo = OLD.saldo - v_monto;

                ELSE

                --  mensaje de error en mysql
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
            END IF;
    END IF;
END;
//

--------------------------------------------------------------------------------------------------------
-- TRIGGER PARA CONSULTA


DELIMITER //
CREATE TRIGGER tg_consulta
BEFORE UPDATE ON tb_tarjetas
FOR EACH ROW
BEGIN
    DECLARE consulta_id INT;

    -- Consulta el id_tipo_movimiento
    SELECT id_tipo_movimiento INTO consulta_id
    FROM tb_tipo_movimientos
    WHERE tipo = 'consulta';

    -- Registrar la consulta de saldo
    INSERT INTO tb_movimientos (monto, id_tarjeta, id_tipo_movimiento)
    VALUES (0, OLD.id_tarjeta, consulta_id);
END;
//
