<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" errorPage="error.jsp" %>
<%@ page import="java.util.ArrayList,java.util.List,java.util.Map,java.util.HashMap" %>
<%@ include file="WEB-INF/comun.jspf" %>
<%-- isErrorPage permite controlar también PUT/OPTIONS con Jasper, sin su respuesta automática. --%>
<%@ page isErrorPage="true" %>
<%
request.setCharacterEncoding("UTF-8"); // Antes de getParameter.
List<String> errores = new ArrayList<>();
if (!"POST".equals(request.getMethod())) {
    response.setStatus(405); response.setHeader("Allow", "POST");
    errores.add("Este enlace solo acepta formularios enviados por POST.");
} else {
    String nombre = normalizar(request.getParameter("nombre"));
    String correo = normalizar(request.getParameter("correo"));
    if (nombre.isEmpty() || nombre.codePointCount(0, nombre.length()) > 100 || nombre.matches("(?s).*[\\p{Cc}].*")) {
        errores.add("Escribe un nombre de entre 1 y 100 caracteres, sin caracteres de control.");
    }
    String patron = "^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$";
    if (correo.length() > 254 || correo.indexOf('@') > 64 || !correo.matches(patron)) {
        errores.add("Escribe un correo electrónico válido de hasta 254 caracteres.");
    }
    if (errores.isEmpty()) {
        // session es un objeto implícito: no declarar HttpSession session otra vez.
        synchronized (session) {
            List<Map<String,String>> registros = (List<Map<String,String>>) session.getAttribute("registros");
            if (registros == null) { registros = new ArrayList<>(); }
            Map<String,String> contacto = new HashMap<>();
            contacto.put("nombre", nombre); contacto.put("correo", correo);
            registros.add(contacto); session.setAttribute("registros", registros);
            session.setAttribute("exito", Boolean.TRUE);
        }
        response.setStatus(303); response.setHeader("Location", "registros.jsp"); return;
    }
    response.setStatus(400);
}
%>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Revisa los datos | Contactos</title><link rel="stylesheet" href="assets/styles.css"></head>
<body><main class="card"><p class="eyebrow">CAMPUS · REGISTRO DE CONTACTO</p>
<span class="badge">Revisemos los datos</span><h1>No se registró el contacto.</h1>
<div class="notice error" role="alert"><ul>
<% for (String error : errores) { %><li><%= escapar(error) %></li><% } %>
</ul></div><a class="button" href="index.jsp">Volver al formulario</a><a class="secondary" href="registros.jsp">Ver contactos guardados</a>
</main></body></html>
