<?php 
//print_r($_POST);

session_start();

if(isset($_POST['n_tarjeta']) && isset($_POST['nip'])){
    require './conn.php';
    
    $n_tarjeta = $_POST['n_tarjeta'];
    $nip = $_POST['nip'];
    $sql = "call sp_login($n_tarjeta, $nip)";
    /*$sql = "SELECT id_tarjeta,n_tarjeta,nip, saldo,nombre, ap_paterno, ap_materno
            FROM tb_tarjetas
            INNER JOIN tb_clientes
            ON tb_tarjetas.id_cliente = tb_clientes.id_cliente*/
            
    $result = $conexion->query($sql);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $_SESSION['id'] = $row['id_tarjeta'];
        $_SESSION['n_tarjeta'] = $row['n_tarjeta'];
        $_SESSION['saldo'] = $row['saldo'];
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
}


?>