# Script para actualizar las imágenes de descripción de carreras
$sourceDir = "Nueva imagen carreras-TSU _ Mapas curricular\CORTADOS Y BOTONES"
$targetBaseDir = "assets\images\carreras"

# Mapeo de nombres de archivos a carpetas de destino
$fileMapping = @{
    "UPBC_Descripcióndecarrera_ADMINISTRACION-01.jpg" = "administracion\descripcion.jpg"
    "UPBC_Descripcióndecarrera_ANIMACION-01.jpg" = "animacion\descripcion.jpg"
    "UPBC_Descripcióndecarrera_EDUCACION-01.jpg" = "educacion\descripcion.jpg"
    "UPBC_Descripcióndecarrera_ENERGIA-01.jpg" = "energia\descripcion.jpg"
    "UPBC_Descripcióndecarrera_GASTRONOMIA-01.jpg" = "gastronomia\descripcion.jpg"
    "UPBC_Descripcióndecarrera_INDUSTRIAL-01.jpg" = "industrial\descripcion.jpg"
    "UPBC_Descripcióndecarrera_MANUFACTURA-01.jpg" = "manufactura\descripcion.jpg"
    "UPBC_Descripcióndecarrera_MECATRONICA-01.jpg" = "mecatronica\descripcion.jpg"
    "UPBC_Descripcióndecarrera_NEGOCIOSyMERCADOTECNIA-01.jpg" = "negocios\descripcion.jpg"
    "UPBC_Descripcióndecarrera_SEMICONDUCTORES-01.jpg" = "microelectronica\descripcion.jpg"
    "UPBC_Descripcióndecarrera_TI-01.jpg" = "tecnologias\descripcion.jpg"
}

# Copiar las imágenes de títulos a una carpeta común
$titleImages = @(
    "UPBC_PAGWEB_Campolaboral.png",
    "UPBC_PAGWEB_PerfildeEgreso.png",
    "UPBC_PAGWEB_PerfildeIngreso.png"
)

# Crear directorio para los títulos si no existe
$titleDir = Join-Path $targetBaseDir "titles"
if (-not (Test-Path $titleDir)) {
    New-Item -Path $titleDir -ItemType Directory | Out-Null
    Write-Host "Creado directorio para imágenes de títulos: $titleDir" -ForegroundColor Green
}

# Copiar imágenes de títulos
foreach ($titleImage in $titleImages) {
    $sourcePath = Join-Path $sourceDir $titleImage
    $targetPath = Join-Path $titleDir $titleImage
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        Write-Host "Copiada imagen de título: $titleImage" -ForegroundColor Green
    } else {
        Write-Host "No se encontró la imagen de título: $titleImage" -ForegroundColor Red
    }
}

# Copiar imágenes de descripción de carreras
$count = 0
foreach ($file in $fileMapping.Keys) {
    $sourcePath = Join-Path $sourceDir $file
    $targetPath = Join-Path $targetBaseDir $fileMapping[$file]
    
    # Asegurarse de que el directorio de destino existe
    $targetDir = Split-Path -Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -Path $targetDir -ItemType Directory | Out-Null
        Write-Host "Creado directorio: $targetDir" -ForegroundColor Yellow
    }
    
    # Copiar el archivo
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        Write-Host "Copiada imagen de descripción para: $($fileMapping[$file])" -ForegroundColor Green
        $count++
    } else {
        Write-Host "No se encontró la imagen de origen: $file" -ForegroundColor Red
    }
}

Write-Host "`nResumen:" -ForegroundColor Cyan
Write-Host "Total de imágenes de descripción copiadas: $count de $($fileMapping.Count)" -ForegroundColor White
Write-Host "Total de imágenes de títulos copiadas: $($titleImages.Count)" -ForegroundColor White
