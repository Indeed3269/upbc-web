# Script para actualizar la información de las carreras

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
        $content = Get-Content -Path $htmlFile -Raw
        $originalContent = $content
        
        # 1. Actualizar la duración a diez cuatrimestres
        $content = $content -replace '<h4>Duración</h4>\s*<p>[^<]*</p>', '<h4>Duración</h4>
            <p>10 cuatrimestres</p>'
        
        # 2. Asegurarse que la modalidad sea Presencial
        $content = $content -replace '<h4>Modalidad</h4>\s*<p>[^<]*</p>', '<h4>Modalidad</h4>
            <p>Presencial</p>'
        
        # 3. Actualizar el título que otorga a Técnico Superior Universitario
        $content = $content -replace '<h4>Título que otorga</h4>\s*<p>[^<]*</p>', '<h4>Título que otorga</h4>
            <p>Técnico Superior Universitario</p>'
        
        # 4. Actualizar el nombre completo de la carrera
        if ($carrerasNombres.ContainsKey($carrera)) {
            $nombreCompleto = $carrerasNombres[$carrera]
            $content = $content -replace '<h1 class="carrera-title">[^<]*</h1>', "<h1 class=`"carrera-title`">$nombreCompleto</h1>"
        }
        
        # 5. Eliminar la sección de requisitos de ingreso
        $content = $content -replace '<div class="carrera-info-box">\s*<h4>Requisitos de ingreso</h4>[\s\S]*?</ul>\s*</div>', ''
        
        # 6. Eliminar la sección de Software Especializado si existe
        $content = $content -replace '<div class="carrera-info-box">\s*<h4>Software Especializado</h4>[\s\S]*?</ul>\s*</div>', ''
        
        # Guardar el archivo solo si se hicieron cambios
        if ($content -ne $originalContent) {
            Set-Content -Path $htmlFile -Value $content -Encoding UTF8
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
