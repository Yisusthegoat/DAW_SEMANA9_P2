<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';
$registros = $_SESSION['registros'] ?? [];
$exito = $_SESSION['exito'] ?? false;
unset($_SESSION['exito']);
?>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Contactos de la sesión | Contactos</title><link rel="stylesheet" href="assets/styles.css"></head>
<body><main class="card wide"><p class="eyebrow">CAMPUS · REGISTRO DE CONTACTO</p>
<span class="badge">Semana 09 · PHP</span><h1>Tus contactos, reunidos.</h1>
<?php if ($exito): ?><p class="notice success" role="status">Contacto registrado correctamente.</p><?php endif; ?>
<?php if (!$registros): ?><p class="intro">Aún no hay contactos en esta sesión. Registra el primero desde el formulario.</p>
<?php else: ?><div class="table-wrap"><table><caption>Contactos de esta sesión: <?= count($registros) ?></caption>
<thead><tr><th scope="col">N.º</th><th scope="col">Nombre completo</th><th scope="col">Correo electrónico</th></tr></thead><tbody>
<?php foreach ($registros as $i => $registro): ?><tr><td><?= $i + 1 ?></td><td><?= escapar($registro['nombre']) ?></td><td><?= escapar($registro['correo']) ?></td></tr><?php endforeach; ?>
</tbody></table></div><?php endif; ?>
<a class="button" href="index.html">Registrar otro contacto <span aria-hidden="true">→</span></a>
<p class="footnote">Puedes actualizar esta tabla sin duplicar registros. Los contactos duran lo que dure la sesión.</p>
</main></body></html>
