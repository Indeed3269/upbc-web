# Script para copiar imágenes usando Get-ChildItem para manejar caracteres especiales

$sourceDir = "C:\Pagina UPBC\upbc-web\Nueva imagen carreras-TSU _ Mapas curricular\CORTADOS Y BOTONES"
$titleDir = "assets\images\carreras\titles"

# Crear directorio para los títulos si no existe
if (-not (Test-Path $titleDir)) {
    New-Item -Path $titleDir -ItemType Directory | Out-Null
    Write-Host "Creado directorio para imágenes de títulos: $titleDir" -ForegroundColor Green
}

# Mapeo de patrones de búsqueda a destinos
$imageMapping = @{
    "*ADMINISTRACION*.jpg" = "assets\images\carreras\administracion\descripcion.jpg"
    "*ANIMACION*.jpg" = "assets\images\carreras\animacion\descripcion.jpg"
    "*EDUCACION*.jpg" = "assets\images\carreras\educacion\descripcion.jpg"
    "*ENERGIA*.jpg" = "assets\images\carreras\energia\descripcion.jpg"
    "*GASTRONOMIA*.jpg" = "assets\images\carreras\gastronomia\descripcion.jpg"
    "*INDUSTRIAL*.jpg" = "assets\images\carreras\industrial\descripcion.jpg"
    "*MANUFACTURA*.jpg" = "assets\images\carreras\manufactura\descripcion.jpg"
    "*MECATRONICA*.jpg" = "assets\images\carreras\mecatronica\descripcion.jpg"
    "*NEGOCIOS*.jpg" = "assets\images\carreras\negocios\descripcion.jpg"
    "*SEMICONDUCTORES*.jpg" = "assets\images\carreras\microelectronica\descripcion.jpg"
    "*TI*.jpg" = "assets\images\carreras\tecnologias\descripcion.jpg"
    "*Campolaboral*.png" = "$titleDir\campo-laboral.png"
    "*PerfildeEgreso*.png" = "$titleDir\perfil-egreso.png"
    "*PerfildeIngreso*.png" = "$titleDir\perfil-ingreso.png"
}

# Copiar cada imagen según el patrón
foreach ($pattern in $imageMapping.Keys) {
    $files = Get-ChildItem -Path $sourceDir -Filter $pattern
    
    foreach ($file in $files) {
        $destination = $imageMapping[$pattern]
        
        # Asegurarse de que el directorio de destino existe
        $destDir = Split-Path -Path $destination -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -Path $destDir -ItemType Directory | Out-Null
            Write-Host "Creado directorio: $destDir" -ForegroundColor Yellow
        }
        
        # Copiar el archivo
        Copy-Item -Path $file.FullName -Destination $destination -Force
        Write-Host "Copiado: $($file.Name) -> $destination" -ForegroundColor Green
    }
}

Write-Host "`nProceso completado. Todas las imágenes han sido copiadas." -ForegroundColor Cyan
