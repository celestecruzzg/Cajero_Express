<?php
print_r($_POST);
session_start();

if(isset($_POST['n_tarjeta']) && isset($_POST['nip'])){
    require_once './conn.php';
    $n_tarjeta = $_POST['n_tarjeta'];
    $nip = $_POST['nip'];
    $sql = "SELECT id_tarjeta, n_tarjeta, nip, saldo,tb_tarjeta.id_cliente, nombre, ap_paterno, ap_materno
            FROM tb_tarjeta INNER JOIN tb_clientes ON
            tb_tarjeta.id_cliente = tb_clientes.id_cliente
            WHERE n_tarjeta = '$n_tarjeta' AND nip = '$nip'";
   // $sql = "call sp_login('$n_tarjeta','$nip')";
    $result = $conexion->query($sql);
    if($result->num_rows > 0){ 
        $row = $result->fetch_assoc();
        if($row['estado'] == 'Activo'){
            $_SESSION['error'] = 'El usuario ya inicio sesion';
            $result -> free();
            $conexion->next_result();
            header("Location: ../view/bienvenida/index.php");
            exit();
        }
        
        //$sql = "UPDATE tb_clientes SET estado = 'Activo' WHERE id_cliente = " .$row['id_cliente'];
        $id_cliente = $row['id_cliente'];

        $sql_update = "call sp_estado_activo('$id_cliente')";
        
        $conexion->query($sql);

        $_SESSION['id'] = $row['id_tarjeta'];

        echo $_SESSION['id'];

        $_SESSION['n_tarjeta'] = $row['n_tarjeta'];
        $_SESSION['saldo'] = $row['saldo'];
        $_SESSION['id_cliente'] = $row['id_cliente'];
        $_SESSION['nombre'] = $row['nombre'];
        $_SESSION['ap_paterno'] = $row['ap_paterno'];
        $_SESSION['ap_materno'] = $row['ap_materno'];



        header("Location: ../view/bienvenida/index.php");
    }else{
        $_SESSION['error'] = "El número de tarjeta o el NIP son incorrectos";
        header("Location: ../index.html");
    }
}else{
    $_SESSION['error'] = "Completa todos los campos";
    header("Location: ../index.html");
};


$n_tarjeta = $_POST['n_tarjeta'];
$nip = $_POST['nip'];

?>