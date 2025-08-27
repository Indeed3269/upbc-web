# Script para corregir problemas de codificación en archivos HTML
# Este script reescribe los archivos con codificación UTF-8 correcta

# Función para corregir la codificación de un archivo
function Fix-Encoding {
    param (
        [string]$filePath
    )
    
    Write-Host "Procesando archivo: $filePath"
    
    try {
        # Leer el contenido del archivo con detección automática de codificación
        $content = [System.IO.File]::ReadAllText($filePath)
        
        # Reemplazos específicos para caracteres mal codificados
        $content = $content -replace "Ã­", "í"
        $content = $content -replace "Ã³", "ó"
        $content = $content -replace "Ã©", "é"
        $content = $content -replace "Ã¡", "á"
        $content = $content -replace "Ãº", "ú"
        $content = $content -replace "Ã±", "ñ"
        
        # Reemplazos específicos para textos comunes
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
        $content = $content -replace "IntegraciÃ³n", "Integración"
        $content = $content -replace "RevoluciÃ³n", "Revolución"
        $content = $content -replace "Â¿", "¿"
        
        # Reemplazar directamente las etiquetas meta y title con problemas
        $content = $content -replace '<meta name="description" content="IngenierÃ­a en AnimaciÃ³n y Efectos Visuales - Universidad PolitÃ©cnica de Baja California">', '<meta name="description" content="Ingeniería en Animación y Efectos Visuales - Universidad Politécnica de Baja California">'
        $content = $content -replace '<title>IngenierÃ­a en AnimaciÃ³n y Efectos Visuales - UPBC</title>', '<title>Ingeniería en Animación y Efectos Visuales - UPBC</title>'
        
        # Guardar el archivo con codificación UTF-8 sin BOM
        $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBomEncoding)
        
        Write-Host "Archivo procesado correctamente: $filePath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error al procesar el archivo $filePath : $_" -ForegroundColor Red
    }
}

# Procesar la página de animación específicamente
$animacionHtml = "c:\Pagina UPBC\upbc-web\carreras\animacion\animacion.html"
if (Test-Path $animacionHtml) {
    Fix-Encoding -filePath $animacionHtml
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
