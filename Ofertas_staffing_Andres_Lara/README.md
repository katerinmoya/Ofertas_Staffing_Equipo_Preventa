# Ofertas Staffing

Este repositorio contiene una pequeña aplicación de generación de ofertas comerciales.
Incluye una interfaz frontend estática en `Frond_end/` y un backend mínimo en Python/Flask en `Back_end/Main.py`.

## Requisitos previos

- Windows 10/11 (o similar)
- Python 3.8+ instalado
- Conexión a internet (para instalar dependencias)

## Configuración local (rápido)

1. Abre PowerShell y sitúate en la carpeta del proyecto:

```powershell
cd "c:\Users\MOYAK\Downloads\Ofertas_staffing_Andres_Lara"
```

2. Crea y activa un entorno virtual (si no existe ya `.venv`):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

3. Instala dependencias:

```powershell
pip install -r requirements.txt
```

4. Inicia el backend Flask:

```powershell
.\.venv\Scripts\Activate.ps1
python Back_end\Main.py
```

5. Abre en tu navegador:

```
http://127.0.0.1:5000/
```

La página de inicio es `Frond_end/Login.html` y desde ahí navegas el flujo completo.

---

## Compartir la app en tu red local (LAN)

Si quieres que otros en tu red local accedan a la app:

1. Ejecuta el backend como en la sección anterior. El servidor por defecto escucha en `0.0.0.0:5000`.
2. Averigua la IP local de la máquina host (ejecuta en PowerShell):

```powershell
ipconfig
```

Busca la `IPv4` de la interfaz de red (ej. `192.168.1.10`).

3. En otra máquina de la misma red abre:

```
http://192.168.1.10:5000/
```

4. Si no se puede conectar, abre el puerto 5000 en el firewall (ejecuta PowerShell como Administrador):

```powershell
New-NetFirewallRule -DisplayName "Flask 5000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5000
```

Y asegúrate de que la red en Windows esté en modo "Privada".

---

## Compartir públicamente (temporal) con ngrok

Si quieres exponer la app a alguien fuera de tu red (temporalmente), `ngrok` crea un túnel HTTPS a tu puerto local.

1. Descarga ngrok desde https://ngrok.com/ e instala.
2. Autentica tu cliente ngrok (una sola vez):

```powershell
ngrok authtoken <TU_AUTHTOKEN>
```

3. Ejecuta el túnel apuntando al puerto 5000:

```powershell
ngrok http 5000
```

4. Ngrok mostrará una URL pública (por ejemplo `https://abcd1234.ngrok.io`) que puedes compartir.

Notas de seguridad: cualquiera con la URL podrá acceder mientras ngrok esté activo. No expongas datos sensibles.

---

## Compartir solo los archivos (sin servidor)

Si el receptor solo necesita ver los archivos estáticos sin backend, comprime el proyecto y envíalo:

```powershell
Compress-Archive -Path .\* -DestinationPath ..\oferta_staffing.zip
```

El receptor puede extraer y abrir `Frond_end/Login.html` directamente en el navegador usando la ruta `file:///`, pero algunas funciones que llaman a la API no funcionarán sin el backend.

---

## Notas importantes y solución de problemas

- Diferencia `file:///` vs `http://`: varias funciones en el frontend consultan la API en `http://127.0.0.1:5000`. Si abres los HTML directamente con `file:///`, esas llamadas fallarán salvo que indiques lo contrario. Se recomienda ejecutar el backend y usar `http://127.0.0.1:5000/`.
- Si la descarga de PPT falla, revisa la consola del backend (PowerShell) para ver errores. Asegúrate de tener `python-pptx` instalado (está en `requirements.txt`).
- Si compartes por LAN y la otra máquina no se conecta, revisa el firewall, desactiva temporalmente el antivirus y comprueba la IP correcta.

---

## Comandos rápidos de referencia

```powershell
# Activar venv (desde la carpeta del proyecto)
.\.venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar backend
python Back_end\Main.py

# Abrir en local
start http://127.0.0.1:5000/
```

---

## Despliegue automático en Render

Este proyecto ya incluye un archivo [render.yaml](render.yaml) para despliegue automático en Render.

### Pasos

1. Sube el proyecto a GitHub si todavía no lo has hecho.
2. Entra a https://render.com/ y crea una cuenta.
3. En Render selecciona "New" → "Blueprint App".
4. Conecta tu repositorio de GitHub y selecciona la carpeta del proyecto.
5. Render leerá automáticamente [render.yaml](render.yaml) y hará el build y el despliegue sin configuraciones manuales.
6. Al terminar, Render te dará una URL pública como `https://tu-app.onrender.com/`.

### Configuración usada

- Build command: `pip install -r requirements.txt`
- Start command: `gunicorn Back_end.Main:app --bind 0.0.0.0:$PORT`

Con eso, cuando alguien entre a la URL compartida, verá el login de la app.
