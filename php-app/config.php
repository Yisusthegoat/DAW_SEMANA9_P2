<?php
declare(strict_types=1);
// Este archivo se carga antes de cualquier salida en las páginas dinámicas.
ini_set('display_errors', '0');
ini_set('log_errors', '1');
set_exception_handler(function (Throwable $error): void {
    error_log('[contactos-grupal] ' . (string) $error);
    if (ob_get_level() > 0) { ob_clean(); }
    http_response_code(500);
    header('Content-Type: text/html; charset=UTF-8');
    echo '<!DOCTYPE html><html lang="es"><meta charset="UTF-8"><title>Error</title><h1>No pudimos completar la solicitud.</h1><p>Inténtalo más tarde.</p><a href="index.html">Volver al formulario</a></html>';
});
set_error_handler(function (int $nivel, string $mensaje, string $archivo, int $linea): bool {
    if (!(error_reporting() & $nivel)) { return false; }
    throw new ErrorException($mensaje, 0, $nivel, $archivo, $linea);
});
ob_start();
session_name('CONTACTOSGRUPALPHP');
session_set_cookie_params(['httponly' => true, 'samesite' => 'Lax', 'path' => '/DAW_SEMANA9_GRUPAL/php-app/']);
session_start();
header('Content-Type: text/html; charset=UTF-8');
header('Cache-Control: no-store');
header('X-Content-Type-Options: nosniff');
function escapar(string $texto): string {
    return htmlspecialchars($texto, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
function normalizar($valor): string {
    if (!is_string($valor) || preg_match('//u', $valor) !== 1) { return ''; }
    return preg_replace('/^[\s\p{Z}]+|[\s\p{Z}]+$/u', '', $valor) ?? '';
}
