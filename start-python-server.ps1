# Script para iniciar un servidor web Python
# Este script utiliza el módulo http.server de Python para crear un servidor web básico

$port = 8080
$rootPath = $PSScriptRoot

Write-Host "Iniciando servidor web Python en http://localhost:$port/"
Write-Host "Directorio raíz: $rootPath"
Write-Host "Presiona Ctrl+C para detener el servidor"

# Cambiar al directorio raíz
Set-Location -Path $rootPath

# Intentar iniciar el servidor con Python
try {
    # Primero intentamos con python3
    python3 -m http.server $port
}
catch {
    try {
        # Si falla, intentamos con python
        python -m http.server $port
    }
    catch {
        try {
            # Si ambos fallan, intentamos con py
            py -m http.server $port
        }
        catch {
            Write-Host "No se pudo iniciar el servidor Python. Asegúrate de tener Python instalado."
            exit 1
        }
    }
}
