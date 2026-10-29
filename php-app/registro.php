<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';
$errores = [];
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); header('Allow: POST');
    $errores[] = 'Este enlace solo acepta formularios enviados por POST.';
} else {
    $nombre = normalizar($_POST['nombre'] ?? null);
    $correo = normalizar($_POST['correo'] ?? null);
    if ($nombre === '' || preg_match_all('/./us', $nombre) > 100 || preg_match('/[\p{Cc}]/u', $nombre)) {
        $errores[] = 'Escribe un nombre de entre 1 y 100 caracteres, sin caracteres de control.';
    }
    if (strlen($correo) > 254 || !filter_var($correo, FILTER_VALIDATE_EMAIL)) {
        $errores[] = 'Escribe un correo electrónico válido de hasta 254 caracteres.';
    }
    if (!$errores) {
        $_SESSION['registros'][] = ['nombre' => $nombre, 'correo' => $correo];
        $_SESSION['exito'] = true;
        // PRG: actualizar la tabla repite un GET, no el POST que inserta.
        header('Location: registros.php', true, 303); exit;
    }
    http_response_code(400);
}
?>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Revisa los datos | Contactos</title><link rel="stylesheet" href="assets/styles.css"></head>
<body><main class="card"><p class="eyebrow">CAMPUS · REGISTRO DE CONTACTO</p>
<span class="badge">Revisemos los datos</span><h1>No se registró el contacto.</h1>
<div class="notice error" role="alert"><ul>
<?php foreach ($errores as $error): ?><li><?= escapar($error) ?></li><?php endforeach; ?>
</ul></div><a class="button" href="index.html">Volver al formulario</a><a class="secondary" href="registros.php">Ver contactos guardados</a>
</main></body></html>
