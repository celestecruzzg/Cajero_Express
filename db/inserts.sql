/*INSERTANDO USUARIOS*/

INSERT INTO tb_clientes (
	nombre,
	ap_paterno,
	ap_materno) VALUES (
	'Celeste',
	'González',
	'Cruz'
);

INSERT INTO tb_tarjetas (
	n_tarjeta,
    nip,
    saldo,
    id_cliente
) VALUES (
	'4152313720040612',
    '0612',
    50000,
    1
);

INSERT INTO tb_clientes (
	nombre,
	ap_paterno,
	ap_materno) VALUES (
	'Abraham Antonio',
	'García',
	'Rodriguez'
);

INSERT INTO tb_tarjetas (
    n_tarjeta,
    nip,
    saldo,
    id_cliente
) VALUES (
	'4152313720051016',
    '1016',
    40000,
    2
);

INSERT INTO tb_clientes (
	nombre,
	ap_paterno,
	ap_materno) VALUES (
	'Diana Lizbeth',
	'Gómez',
	'Juárez'
);

INSERT INTO tb_tarjetas (
    n_tarjeta,
    nip,
    saldo,
    id_cliente
) VALUES (
	'4152313720050924',
    '0924',
    40000,
    3
);

delete from tb_tarjetas WHERE id_tarjeta = 3;

SELECT n_tarjeta, nip, saldo, tb_clientes.nombre, tb_clientes.ap_paterno, tb_clientes.id_cliente
FROM tb_tarjetas
INNER JOIN tb_clientes
ON tb_tarjetas.id_cliente = tb_clientes.id_cliente;

SELECT * FROM tb_clientes;