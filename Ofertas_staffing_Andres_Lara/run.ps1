# run.ps1 - Automatiza creación de venv, instalación de dependencias y arranque del backend
# Uso: Ejecutar desde la carpeta del proyecto: .\run.ps1

Set-StrictMode -Version Latest

Push-Location $PSScriptRoot

try {
    Write-Host "Comprobando Python y entorno virtual..."

    if (-not (Test-Path ".venv")) {
        Write-Host "No existe .venv: creando entorno virtual..."
        python -m venv .venv
    } else {
        Write-Host "Entorno virtual .venv ya existe."
    }

    $venvPython = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"

    if (-not (Test-Path $venvPython)) {
        Write-Error "No se encontró el ejecutable de Python en .venv. Asegúrate de que python esté en PATH y vuelve a intentar.";
        exit 1
    }

    Write-Host "Actualizando pip e instalando dependencias desde requirements.txt..."
    & $venvPython -m pip install --upgrade pip
    & $venvPython -m pip install -r requirements.txt

    Write-Host "Iniciando backend (se abrirá en un proceso separado)..."
    Start-Process -FilePath $venvPython -ArgumentList "Back_end\Main.py" -WindowStyle Normal

    Start-Sleep -Seconds 1
    Write-Host "Abriendo navegador en http://127.0.0.1:5000/"
    Start-Process "http://127.0.0.1:5000/"

    Write-Host "Listo. Si quieres detener el backend, busca el proceso python iniciado o cierra la ventana nueva de PowerShell.";
} finally {
    Pop-Location
}
