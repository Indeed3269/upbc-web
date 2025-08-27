# Script para corregir problemas de codificación en metadatos y títulos HTML
# Este script se enfoca en corregir los caracteres especiales en las etiquetas meta y title

# Definir la función para corregir la codificación
function Fix-Encoding-Meta {
    param (
        [string]$filePath
    )
    
    Write-Host "Procesando archivo: $filePath"
    
    # Leer el contenido del archivo con codificación UTF-8
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    # Reemplazos específicos para metadatos y títulos
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada en Animaci\u00c3\u00b3n y Efectos Visuales', '<meta name="description" content="Ingeniería en Animación y Efectos Visuales'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada en Energ\u00c3\u00ada', '<meta name="description" content="Ingeniería en Energía'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada Mecatr\u00c3\u00b3nica', '<meta name="description" content="Ingeniería Mecatrónica'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada en Tecnolog\u00c3\u00adas', '<meta name="description" content="Ingeniería en Tecnologías'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada en Manufactura', '<meta name="description" content="Ingeniería en Manufactura'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada en Microelectr\u00c3\u00b3nica', '<meta name="description" content="Ingeniería en Microelectrónica'
    $content = $content -replace '<meta name="description" content="Ingenier\u00c3\u00ada Industrial', '<meta name="description" content="Ingeniería Industrial'
    $content = $content -replace '<meta name="description" content="Licenciatura en Administraci\u00c3\u00b3n', '<meta name="description" content="Licenciatura en Administración'
    $content = $content -replace '<meta name="description" content="Licenciatura en Educaci\u00c3\u00b3n', '<meta name="description" content="Licenciatura en Educación'
    $content = $content -replace '<meta name="description" content="Licenciatura en Gastronom\u00c3\u00ada', '<meta name="description" content="Licenciatura en Gastronomía'
    $content = $content -replace '<meta name="description" content="Licenciatura en Negocios y Mercadotecnia', '<meta name="description" content="Licenciatura en Negocios y Mercadotecnia'
    
    # Corregir Universidad Politécnica en metadatos
    $content = $content -replace 'Universidad Polit\u00c3\u00a9cnica', 'Universidad Politécnica'
    
    # Corregir títulos
    $content = $content -replace '<title>Ingenier\u00c3\u00ada en Animaci\u00c3\u00b3n y Efectos Visuales', '<title>Ingeniería en Animación y Efectos Visuales'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada en Energ\u00c3\u00ada', '<title>Ingeniería en Energía'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada Mecatr\u00c3\u00b3nica', '<title>Ingeniería Mecatrónica'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada en Tecnolog\u00c3\u00adas', '<title>Ingeniería en Tecnologías'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada en Manufactura', '<title>Ingeniería en Manufactura'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada en Microelectr\u00c3\u00b3nica', '<title>Ingeniería en Microelectrónica'
    $content = $content -replace '<title>Ingenier\u00c3\u00ada Industrial', '<title>Ingeniería Industrial'
    $content = $content -replace '<title>Licenciatura en Administraci\u00c3\u00b3n', '<title>Licenciatura en Administración'
    $content = $content -replace '<title>Licenciatura en Educaci\u00c3\u00b3n', '<title>Licenciatura en Educación'
    $content = $content -replace '<title>Licenciatura en Gastronom\u00c3\u00ada', '<title>Licenciatura en Gastronomía'
    $content = $content -replace '<title>Licenciatura en Negocios y Mercadotecnia', '<title>Licenciatura en Negocios y Mercadotecnia'
    
    # Corregir encabezados h1 y h2
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada en Animaci\u00c3\u00b3n y Efectos Visuales</h1>', '<h1 class="carrera-title">Ingeniería en Animación y Efectos Visuales</h1>'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada en Energ\u00c3\u00ada', '<h1 class="carrera-title">Ingeniería en Energía'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada Mecatr\u00c3\u00b3nica</h1>', '<h1 class="carrera-title">Ingeniería Mecatrónica</h1>'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada en Tecnolog\u00c3\u00adas', '<h1 class="carrera-title">Ingeniería en Tecnologías'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada en Manufactura', '<h1 class="carrera-title">Ingeniería en Manufactura'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada en Microelectr\u00c3\u00b3nica', '<h1 class="carrera-title">Ingeniería en Microelectrónica'
    $content = $content -replace '<h1 class="carrera-title">Ingenier\u00c3\u00ada Industrial</h1>', '<h1 class="carrera-title">Ingeniería Industrial</h1>'
    $content = $content -replace '<h1 class="carrera-title">Licenciatura en Administraci\u00c3\u00b3n</h1>', '<h1 class="carrera-title">Licenciatura en Administración</h1>'
    $content = $content -replace '<h1 class="carrera-title">Licenciatura en Educaci\u00c3\u00b3n</h1>', '<h1 class="carrera-title">Licenciatura en Educación</h1>'
    $content = $content -replace '<h1 class="carrera-title">Licenciatura en Gastronom\u00c3\u00ada</h1>', '<h1 class="carrera-title">Licenciatura en Gastronomía</h1>'
    $content = $content -replace '<h1 class="carrera-title">Licenciatura en Negocios y Mercadotecnia</h1>', '<h1 class="carrera-title">Licenciatura en Negocios y Mercadotecnia</h1>'
    
    # Corregir subtítulos
    $content = $content -replace '<h2 class="carrera-subtitle">Descripci\u00c3\u00b3n', '<h2 class="carrera-subtitle">Descripción'
    $content = $content -replace '<h3 class="carrera-section-title">Descripci\u00c3\u00b3n', '<h3 class="carrera-section-title">Descripción'
    
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
        Fix-Encoding-Meta -filePath $htmlFile
    } else {
        Write-Host "No se encontró el archivo HTML para la carrera: $($carrera.Name)" -ForegroundColor Yellow
    }
}

Write-Host "Proceso completado. Todos los archivos han sido corregidos." -ForegroundColor Green
