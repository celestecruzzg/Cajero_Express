<?php 

session_start();

if(!isset($_SESSION['id'])){
    header("Location: ../../index.html");
}

$saldo = $_SESSION['saldo'];
?>

<!doctype html>
<html lang="es">

<head>
    <title>Cajero Express</title>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <!-- Bootstrap CSS v5.2.1 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous" />
    <!-- LINKS ASSETS -->
    <link rel="stylesheet" href="../../assets/css/normalize.css">
    <link rel="stylesheet" href="../../assets/css/style_retiro.css">
    <!-- LINKS FONTS -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&display=swap" rel="stylesheet">
    <!-- LINK ICONS -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <!-- LINK FAVICON -->
    <link rel="shortcut icon" href="../../assets/image/favicon.ico" type="image/x-icon">
</head>

<body class="body">
    <header>
        <nav class="navbar">
            <div class="navbar-content">
                <span class="material-icons logo">account_balance</span>
                <p class="nombre_banco">Cajero Express | Banco Nacional de México</p>
            </div>
        </nav>
    </header>
    <main>
        <h1>Retiro</h1>
        <h2>$<?= $saldo; ?>MXN</h2>
        <p class="saldo">Saldo actual</p>
        <div class="container">
            <a href="#" class="btn btn-1">$50.00 MXN</a>
            <a href="#" class="btn btn-2">$100.00 MXN</a>
            <a href="#" class="btn btn-3">$200.00 MXN</a>
            <a href="#" class="btn btn-4">$500.00 MXN</a>
        </div>
        <div class="input-button-box">
            <form action="update.php" method="post">
                <label for="otroMonto" class="otro_monto">Otro monto:</label>
                <input type="number" class="input" id="otroMonto" name="otroMonto" maxlength="19" placeholder="Ejemplo: $1,000.00" />
                <button type="submit" class="btn btn-enviar" id="btnRetirarMonto">Retirar</button>
            </form>
        </div>
        <div class="regresar">
            <a href="../bienvenida/index.php" class="btn btn-7">
                <i class="material-icons logout">arrow_back_ios</i>
                Regresar al inicio
            </a>
        </div>
    </main>
    <footer>
        <!-- place footer here -->
    </footer>
    <!-- Bootstrap JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</body>

</html>