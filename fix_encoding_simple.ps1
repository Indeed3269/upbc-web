# Script para corregir problemas de codificación en archivos HTML
# Este script reemplaza directamente los caracteres mal codificados

# Definir la función para corregir la codificación
function Fix-Encoding-Simple {
    param (
        [string]$filePath
    )
    
    Write-Host "Procesando archivo: $filePath"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $filePath -Raw
    
    # Reemplazos directos para caracteres mal codificados
    $content = $content -replace "Ã­", "í"
    $content = $content -replace "Ã³", "ó"
    $content = $content -replace "Ã©", "é"
    $content = $content -replace "Ã¡", "á"
    $content = $content -replace "Ãº", "ú"
    $content = $content -replace "Ã±", "ñ"
    $content = $content -replace "IngenierÃ­a", "Ingeniería"
    $content = $content -replace "AnimaciÃ³n", "Animación"
    $content = $content -replace "DescripciÃ³n", "Descripción"
    $content = $content -replace "DuraciÃ³n", "Duración"
    $content = $content -replace "TÃ­tulo", "Título"
    $content = $content -replace "PolitÃ©cnica", "Politécnica"
    $content = $content -replace "EnergÃ­a", "Energía"
    $content = $content -replace "MecatrÃ³nica", "Mecatrónica"
    $content = $content -replace "TecnologÃ­as", "Tecnologías"
    $content = $content -replace "MicroelectrÃ³nica", "Microelectrónica"
    $content = $content -replace "AdministraciÃ³n", "Administración"
    $content = $content -replace "EducaciÃ³n", "Educación"
    $content = $content -replace "GastronomÃ­a", "Gastronomía"
    $content = $content -replace "InnovaciÃ³n", "Innovación"
    $content = $content -replace "IntegracionÃ³n", "Integración"
    $content = $content -replace "IntegraciÃ³n", "Integración"
    $content = $content -replace "RevoluciÃ³n", "Revolución"
    $content = $content -replace "Â¿", "¿"
    
    # Guardar el archivo con codificación UTF-8 sin BOM
    $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBomEncoding)
    
    Write-Host "Archivo procesado correctamente: $filePath" -ForegroundColor Green
}

# Obtener la lista de todas las carreras
$carrerasPath = "c:\Pagina UPBC\upbc-web\carreras"
$carreras = Get-ChildItem -Path $carrerasPath -Directory

# Procesar cada carrera
foreach ($carrera in $carreras) {
    $htmlFile = Join-Path -Path $carrera.FullName -ChildPath "$($carrera.Name).html"
    
    # Verificar si existe el archivo HTML
    if (Test-Path $htmlFile) {
        Fix-Encoding-Simple -filePath $htmlFile
    } else {
        Write-Host "No se encontró el archivo HTML para la carrera: $($carrera.Name)" -ForegroundColor Yellow
    }
}

Write-Host "Proceso completado. Todos los archivos han sido corregidos." -ForegroundColor Green
