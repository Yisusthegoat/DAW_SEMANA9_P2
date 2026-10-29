<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
Throwable causa = exception;
if (causa == null) { causa = (Throwable) request.getAttribute("javax.servlet.error.exception"); }
application.log("[contactos-grupal] Error inesperado", causa);
response.setStatus(500); response.setHeader("Cache-Control", "no-store");
%>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Error | Contactos</title><link rel="stylesheet" href="assets/styles.css"></head>
<body><main class="card"><p class="eyebrow">CAMPUS · REGISTRO DE CONTACTO</p>
<h1>No pudimos completar la solicitud.</h1><p class="intro">Inténtalo más tarde.</p><a class="button" href="index.jsp">Volver al formulario</a></main></body></html>
