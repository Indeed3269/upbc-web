# Script para corregir problemas de codificación en las páginas HTML

# Lista de carpetas de carreras
$carrerasFolders = @(
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

# Mapeo de nombres completos de carreras
$carrerasNombres = @{
    "administracion" = "Licenciatura en Administración"
    "animacion" = "Ingeniería en Animación y Efectos Visuales"
    "educacion" = "Licenciatura en Educación"
    "energia" = "Ingeniería en Energía y Desarrollo Sostenible"
    "gastronomia" = "Licenciatura en Gastronomía"
    "industrial" = "Ingeniería Industrial"
    "manufactura" = "Ingeniería en Manufactura Avanzada"
    "mecatronica" = "Ingeniería Mecatrónica"
    "microelectronica" = "Ingeniería en Microelectrónica y Semiconductores"
    "negocios" = "Licenciatura en Negocios y Mercadotecnia"
    "tecnologias" = "Ingeniería en Tecnologías de la Información e Innovación Digital"
}

# Contador de archivos actualizados
$updatedFiles = 0

# Recorrer cada carpeta de carrera
foreach ($carrera in $carrerasFolders) {
    $htmlFile = "carreras\$carrera\$carrera.html"
    
    if (Test-Path $htmlFile) {
        # Leer el archivo con la codificación correcta
        $content = Get-Content -Path $htmlFile -Raw
        $originalContent = $content
        
        # Reemplazar caracteres mal codificados
        $content = $content -replace "Ã­", "í"
        $content = $content -replace "Ã³", "ó"
        $content = $content -replace "Ã¡", "á"
        $content = $content -replace "Ã©", "é"
        $content = $content -replace "Ãº", "ú"
        $content = $content -replace "Ã±", "ñ"
        $content = $content -replace "Ã", "í"
        $content = $content -replace "Â¿", "¿"
        $content = $content -replace "Â", ""
        
        # Actualizar título de la carrera
        $content = $content -replace '<h1 class="carrera-title">[^<]*</h1>', "<h1 class=`"carrera-title`">$($carrerasNombres[$carrera])</h1>"
        
        # Actualizar campos específicos
        $content = $content -replace '<h4>Duración</h4>\s*<p>[^<]*</p>', '<h4>Duración</h4>
            <p>10 cuatrimestres</p>'
        
        $content = $content -replace '<h4>Modalidad</h4>\s*<p>[^<]*</p>', '<h4>Modalidad</h4>
            <p>Presencial</p>'
        
        $content = $content -replace '<h4>Título que otorga</h4>\s*<p>[^<]*</p>', '<h4>Título que otorga</h4>
            <p>Técnico Superior Universitario</p>'
        
        # Guardar el archivo con la codificación correcta
        if ($content -ne $originalContent) {
            [System.IO.File]::WriteAllText($htmlFile, $content)
            Write-Host "Actualizado: $htmlFile" -ForegroundColor Green
            $updatedFiles++
        } else {
            Write-Host "No se requirieron cambios en: $htmlFile" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No se encontró el archivo: $htmlFile" -ForegroundColor Red
    }
}

Write-Host "`nResumen:" -ForegroundColor Cyan
Write-Host "Total de archivos actualizados: $updatedFiles de $($carrerasFolders.Count)" -ForegroundColor White
Write-Host "Proceso completado." -ForegroundColor Cyan
