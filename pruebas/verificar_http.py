"""Pruebas por HTTP con biblioteca estándar. Ejecutar con Apache y Tomcat activos."""
import http.cookiejar
import urllib.request
import urllib.parse
import urllib.error
import re

class SinRedireccion(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None

def cliente():
    return urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()), SinRedireccion())

def pedir(opener, url, method='GET', form=None):
    data=None if form is None else urllib.parse.urlencode(form).encode('utf-8')
    req=urllib.request.Request(url,data=data,method=method)
    try:
        res=opener.open(req,timeout=15)
    except urllib.error.HTTPError as error:
        res=error
    return res.code,res.headers,res.read().decode('utf-8')

total=0
def verificar(nombre,condicion):
    global total
    assert condicion, 'FAIL: '+nombre
    total+=1
    print('PASS:',nombre)

for tech,base,ext in [('PHP','http://localhost/DAW_SEMANA9_GRUPAL/php-app/','php'),('JSP','http://localhost:8080/contactos-grupal/','jsp')]:
    op=cliente(); endpoint=base+'registro.'+ext; tabla=base+'registros.'+ext
    status,headers,body=pedir(op,tabla)
    verificar(tech+' lista vacía',status==200 and 'Aún no hay contactos' in body)
    for method in ['GET','PUT','OPTIONS','HEAD']:
        status,headers,body=pedir(op,endpoint,method)
        verificar(tech+' método '+method,status==405 and headers.get('Allow')=='POST')
    for label,form in [('vacíos',{'nombre':'','correo':''}),('espacios',{'nombre':' \t\u00a0 ','correo':' '}),('correo inválido',{'nombre':'Ana','correo':'bad'}),('nombre largo',{'nombre':'A'*101,'correo':'ana@example.com'}),('correo largo',{'nombre':'Ana','correo':'a'*250+'@example.com'})]:
        status,_,_=pedir(op,endpoint,'POST',form)
        verificar(tech+' '+label,status==400)
    for i,nombre in enumerate(['  Jesús Antonio Ñahuinripa Zamudio  ','María Torres'],1):
        status,headers,_=pedir(op,endpoint,'POST',{'nombre':nombre,'correo':f' persona{i}@example.com '})
        verificar(tech+' registro '+str(i),status==303 and headers.get('Location')=='registros.'+ext)
    status,_,body=pedir(op,tabla)
    verificar(tech+' conserva dos contactos y UTF-8',status==200 and len(re.findall(r'<tr><td>',body))==2 and 'Jesús Antonio Ñahuinripa Zamudio</td>' in body)
    _,_,body=pedir(op,tabla)
    verificar(tech+' actualizar no duplica',len(re.findall(r'<tr><td>',body))==2)
    status,_,_=pedir(op,endpoint,'POST',{'nombre':'<script>alert(1)</script>','correo':'xss@example.com'})
    _,_,body=pedir(op,tabla)
    verificar(tech+' escape HTML',status==303 and '&lt;script&gt;alert(1)&lt;/script&gt;' in body and '<script>alert(1)</script>' not in body)
    _,_,body=pedir(cliente(),tabla)
    verificar(tech+' sesión nueva','Aún no hay contactos' in body)
print(f'{total} comprobaciones HTTP correctas. No fuerza errores 500 ni sustituye la inspección visual.')
