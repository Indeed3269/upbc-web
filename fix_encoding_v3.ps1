# Script para corregir problemas de codificación en páginas HTML
# Este script corrige caracteres especiales mal codificados en archivos HTML

# Definir la función para corregir la codificación
function Fix-Encoding {
    param (
        [string]$filePath
    )
    
    Write-Host "Procesando archivo: $filePath"
    
    # Leer el contenido del archivo con codificación UTF-8
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    # Reemplazos para caracteres especiales comunes mal codificados
    $replacements = @{
        # Vocales con acentos
        '\u00c3\u00a1' = 'á'
        '\u00c3\u00a9' = 'é'
        '\u00c3\u00ad' = 'í'
        '\u00c3\u00b3' = 'ó'
        '\u00c3\u00ba' = 'ú'
        '\u00c3\u00a0' = 'à'
        '\u00c3\u00a8' = 'è'
        '\u00c3\u00ac' = 'ì'
        '\u00c3\u00b2' = 'ò'
        '\u00c3\u00b9' = 'ù'
        
        # Vocales con acentos mayúsculas
        '\u00c3\u0081' = 'Á'
        '\u00c3\u0089' = 'É'
        '\u00c3\u008d' = 'Í'
        '\u00c3\u0093' = 'Ó'
        '\u00c3\u009a' = 'Ú'
        
        # Ñ y ñ
        '\u00c3\u0091' = 'Ñ'
        '\u00c3\u00b1' = 'ñ'
        
        # Otros caracteres especiales
        '\u00c3\u00bc' = 'ü'
        '\u00c3\u009c' = 'Ü'
        '\u00c2\u00bf' = '¿'
        '\u00c2\u00a1' = '¡'
    }
    
    # Aplicar reemplazos
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
        Fix-Encoding -filePath $htmlFile
    } else {
        Write-Host "No se encontró el archivo HTML para la carrera: $($carrera.Name)" -ForegroundColor Yellow
    }
}

Write-Host "Proceso completado. Todos los archivos han sido corregidos." -ForegroundColor Green
