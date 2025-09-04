# Script para aplicar la solución del error MIME a todas las páginas de carreras
# Este script crea una copia local de components-loader.js en cada carpeta de carrera
# y actualiza las referencias en los archivos HTML correspondientes

# Lista de carpetas de carreras
$careerFolders = @(
    "administracion",
    "animacion",
    "educacion",
    "energia",
    "gastronomia",
    "industrial",
    "manufactura",
    "mecatronica",
    "microelectronica",
    "negocios",
    "tecnologias"
)

# Ruta base del proyecto
$basePath = $PSScriptRoot

# Ruta al archivo components-loader.js mejorado
$sourceComponentsLoader = Join-Path -Path $basePath -ChildPath "components-loader.js"

# Verificar que el archivo fuente existe
if (-not (Test-Path $sourceComponentsLoader)) {
    Write-Host "Error: No se encontró el archivo components-loader.js en la raíz del proyecto" -ForegroundColor Red
    exit 1
}

Write-Host "Aplicando solución para el error MIME en páginas de carreras..." -ForegroundColor Cyan

foreach ($career in $careerFolders) {
    $careerPath = Join-Path -Path $basePath -ChildPath "carreras\$career"
    
    # Verificar si existe la carpeta de la carrera
    if (-not (Test-Path $careerPath)) {
        Write-Host "Advertencia: No se encontró la carpeta para la carrera $career" -ForegroundColor Yellow
        continue
    }
    
    # Ruta al archivo HTML de la carrera
    $careerHtmlFile = Join-Path -Path $careerPath -ChildPath "$career.html"
    
    # Verificar si existe el archivo HTML
    if (-not (Test-Path $careerHtmlFile)) {
        Write-Host "Advertencia: No se encontró el archivo HTML para la carrera $career" -ForegroundColor Yellow
        continue
    }
    
    # Ruta al archivo components-loader.js en la carpeta de la carrera
    $targetComponentsLoader = Join-Path -Path $careerPath -ChildPath "components-loader.js"
    
    # Copiar el archivo components-loader.js a la carpeta de la carrera
    Copy-Item -Path $sourceComponentsLoader -Destination $targetComponentsLoader -Force
    Write-Host "Copiado components-loader.js a $career" -ForegroundColor Green
    
    # Leer el contenido del archivo HTML
    $htmlContent = Get-Content -Path $careerHtmlFile -Raw
    
    # Verificar si el archivo ya tiene la referencia local
    if ($htmlContent -match '<script src="components-loader\.js"></script>') {
        Write-Host "La referencia en $career.html ya es local" -ForegroundColor Green
    } else {
        # Reemplazar la referencia a components-loader.js
        $htmlContent = $htmlContent -replace '<script src="../../components-loader\.js"></script>', '<script src="components-loader.js"></script>'
        
        # Guardar el archivo modificado
        $htmlContent | Set-Content -Path $careerHtmlFile -Encoding UTF8
        Write-Host "Actualizada la referencia en $career.html" -ForegroundColor Green
    }
}

Write-Host "Proceso completado. Se ha aplicado la solución a todas las carpetas de carreras disponibles." -ForegroundColor Cyan
Write-Host "Esta solución ayuda a prevenir errores MIME relacionados con la carga de archivos CSS en las páginas de carreras." -ForegroundColor Cyan
