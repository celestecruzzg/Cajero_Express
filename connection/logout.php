<?php
session_start();

require_once './conexion.php';

if(isset($_SESSION['id'])){
    //$sql = "UPDATE tb_clientes SET estado = 'Inactivo' WHERE id_cliente = " .$_SESSION['id_cliente'];
    $id_cliente = $_SESSION['id_cliente'];
    $sql = "call sp_estado_inactivo('$id_cliente')";
    $conexion->query($sql);
    session_destroy();
}

header("Location: ../index.html");
?>