# Script para corregir problemas de codificación en archivos HTML
# Este script reemplaza directamente los caracteres mal codificados

# Definir la función para corregir la codificación
function Fix-Encoding-Direct {
    param (
        [string]$filePath
    )
    
    Write-Host "Procesando archivo: $filePath"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $filePath -Raw
    
    # Reemplazos directos para caracteres mal codificados
    $replacements = @{
        'Ã­' = 'í'
        'Ã³' = 'ó'
        'Ã©' = 'é'
        'Ã¡' = 'á'
        'Ãº' = 'ú'
        'Ã±' = 'ñ'
        'Ã\u00ad' = 'í'
        'Ã\u00b3' = 'ó'
        'Ã\u00a9' = 'é'
        'Ã\u00a1' = 'á'
        'Ã\u00ba' = 'ú'
        'Ã\u00b1' = 'ñ'
        'Ã\u00c3\u00ad' = 'í'
        'Ã\u00c3\u00b3' = 'ó'
        'Ã\u00c3\u00a9' = 'é'
        'Ã\u00c3\u00a1' = 'á'
        'Ã\u00c3\u00ba' = 'ú'
        'Ã\u00c3\u00b1' = 'ñ'
        'IngenierÃ­a' = 'Ingeniería'
        'IngenierÃ\u00ada' = 'Ingeniería'
        'AnimaciÃ³n' = 'Animación'
        'AnimaciÃ\u00b3n' = 'Animación'
        'DescripciÃ³n' = 'Descripción'
        'DescripciÃ\u00b3n' = 'Descripción'
        'DuraciÃ³n' = 'Duración'
        'DuraciÃ\u00b3n' = 'Duración'
        'TÃ­tulo' = 'Título'
        'TÃ\u00adtulo' = 'Título'
        'PolitÃ©cnica' = 'Politécnica'
        'PolitÃ\u00a9cnica' = 'Politécnica'
        'EnergÃ­a' = 'Energía'
        'EnergÃ\u00ada' = 'Energía'
        'MecatrÃ³nica' = 'Mecatrónica'
        'MecatrÃ\u00b3nica' = 'Mecatrónica'
        'TecnologÃ­as' = 'Tecnologías'
        'TecnologÃ\u00adas' = 'Tecnologías'
        'MicroelectrÃ³nica' = 'Microelectrónica'
        'MicroelectrÃ\u00b3nica' = 'Microelectrónica'
        'AdministraciÃ³n' = 'Administración'
        'AdministraciÃ\u00b3n' = 'Administración'
        'EducaciÃ³n' = 'Educación'
        'EducaciÃ\u00b3n' = 'Educación'
        'GastronomÃ­a' = 'Gastronomía'
        'GastronomÃ\u00ada' = 'Gastronomía'
        'InnovaciÃ³n' = 'Innovación'
        'InnovaciÃ\u00b3n' = 'Innovación'
        'IntegracionÃ³n' = 'Integración'
        'IntegracionÃ\u00b3n' = 'Integración'
        'IntegraciÃ³n' = 'Integración'
        'IntegraciÃ\u00b3n' = 'Integración'
        'RevoluciÃ³n' = 'Revolución'
        'RevoluciÃ\u00b3n' = 'Revolución'
        'Â¿' = '¿'
        'Â\u00bf' = '¿'
    }
    
    # Aplicar todos los reemplazos
    foreach ($key in $replacements.Keys) {
        $content = $content -replace $key, $replacements[$key]
    }
    
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
        Fix-Encoding-Direct -filePath $htmlFile
    } else {
        Write-Host "No se encontró el archivo HTML para la carrera: $($carrera.Name)" -ForegroundColor Yellow
    }
}

Write-Host "Proceso completado. Todos los archivos han sido corregidos." -ForegroundColor Green
