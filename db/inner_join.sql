//INNER JOIN

SELECT n_tarjeta, nip, saldo, tb_clientes.id_cliente
FROM tb_tarjetas
INNER JOIN tb_clientes
ON tb_tarjetas.id_cliente = tb_clientes.id_cliente;

