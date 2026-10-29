<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" errorPage="error.jsp" %>
<%@ page import="java.util.ArrayList,java.util.List,java.util.Map,java.util.HashMap" %>
<%@ include file="WEB-INF/comun.jspf" %>
<%
List<Map<String,String>> registros;
boolean exito;
synchronized (session) {
    List<Map<String,String>> guardados = (List<Map<String,String>>) session.getAttribute("registros");
    registros = guardados == null ? new ArrayList<Map<String,String>>() : new ArrayList<Map<String,String>>(guardados);
    exito = Boolean.TRUE.equals(session.getAttribute("exito")); session.removeAttribute("exito");
}
%>
<!DOCTYPE html>
<html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Contactos de la sesión | Contactos</title><link rel="stylesheet" href="assets/styles.css"></head>
<body><main class="card wide"><p class="eyebrow">CAMPUS · REGISTRO DE CONTACTO</p>
<span class="badge">Semana 09 · JSP</span><h1>Tus contactos, reunidos.</h1>
<% if (exito) { %><p class="notice success" role="status">Contacto registrado correctamente.</p><% } %>
<% if (registros.isEmpty()) { %><p class="intro">Aún no hay contactos en esta sesión. Registra el primero desde el formulario.</p>
<% } else { %><div class="table-wrap"><table><caption>Contactos de esta sesión: <%= registros.size() %></caption>
<thead><tr><th scope="col">N.º</th><th scope="col">Nombre completo</th><th scope="col">Correo electrónico</th></tr></thead><tbody>
<% int i=0; for (Map<String,String> contacto : registros) { %><tr><td><%= ++i %></td><td><%= escapar(contacto.get("nombre")) %></td><td><%= escapar(contacto.get("correo")) %></td></tr><% } %>
</tbody></table></div><% } %>
<a class="button" href="index.jsp">Registrar otro contacto <span aria-hidden="true">→</span></a>
<p class="footnote">Puedes actualizar esta tabla sin duplicar registros. Los contactos duran lo que dure la sesión.</p>
</main></body></html>
