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
    $content = $content -replace "Ingenier\u00c3\u00ada", "Ingeniería"
    $content = $content -replace "Mecatr\u00c3\u00b3nica", "Mecatrónica"
    $content = $content -replace "Descripci\u00c3\u00b3n", "Descripción"
    $content = $content -replace "formaci\u00c3\u00b3n", "formación"
    $content = $content -replace "dise\u00c3\u00b1o", "diseño"
    $content = $content -replace "implementaci\u00c3\u00b3n", "implementación"
    $content = $content -replace "mec\u00c3\u00a1nica", "mecánica"
    $content = $content -replace "electr\u00c3\u00b3nica", "electrónica"
    $content = $content -replace "inform\u00c3\u00a1tica", "informática"
    $content = $content -replace "tecnol\u00c3\u00b3gica", "tecnológica"
    $content = $content -replace "Especializaci\u00c3\u00b3n", "Especialización"
    $content = $content -replace "Automatizaci\u00c3\u00b3n", "Automatización"
    $content = $content -replace "El\u00c3\u00a9ctrica", "Eléctrica"
    $content = $content -replace "Rob\u00c3\u00b3tica", "Robótica"
    $content = $content -replace "Duraci\u00c3\u00b3n", "Duración"
    $content = $content -replace "T\u00c3\u00adtulo", "Título"
    $content = $content -replace "T\u00c3\u00a9cnico", "Técnico"
    $content = $content -replace "revoluci\u00c3\u00b3n", "revolución"
    $content = $content -replace "admisi\u00c3\u00b3n", "admisión"
    $content = $content -replace "Informaci\u00c3\u00b3n", "Información"
    $content = $content -replace "men\u00c3\u00ba", "menú"
    $content = $content -replace "ser\u00c3\u00a1s", "serás"
    $content = $content -replace "podr\u00c3\u00a1s", "podrás"
    $content = $content -replace "desempe\u00c3\u00b1arte", "desempeñarte"
    $content = $content -replace "t\u00c3\u00a9cnicas", "técnicas"
    $content = $content -replace "Consultor\u00c3\u00ada", "Consultoría"
    $content = $content -replace "est\u00c3\u00a1", "está"
    $content = $content -replace "te\u00c3\u00b3ricos", "teóricos"
    $content = $content -replace "pr\u00c3\u00a1cticos", "prácticos"
    $content = $content -replace "\u00c3\u00a1reas", "áreas"
    $content = $content -replace "programaci\u00c3\u00b3n", "programación"
    $content = $content -replace "\u00c2\u00bf", "¿"
    $content = $content -replace "\u00c2\u00a1", "¡"
    
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
