# Script para actualizar los títulos de sección en las páginas de carreras

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

# Rutas de las imágenes de títulos
$perfilIngresoImg = "../../assets/images/carreras/titles/perfil-ingreso.png"
$perfilEgresoImg = "../../assets/images/carreras/titles/perfil-egreso.png"
$campoLaboralImg = "../../assets/images/carreras/titles/campo-laboral.png"

# Contador de archivos actualizados
$updatedFiles = 0

# Recorrer cada carpeta de carrera
foreach ($carrera in $carrerasFolders) {
    $htmlFile = "carreras\$carrera\$carrera.html"
    
    if (Test-Path $htmlFile) {
        $content = Get-Content -Path $htmlFile -Raw
        $originalContent = $content
        
        # Agregar el enlace al archivo CSS de section-titles si no existe
        if (-not ($content -match "section-titles\.css")) {
            $cssPattern = '<link rel="stylesheet" href="../../assets/css/carreras\.css">'
            $cssReplacement = '<link rel="stylesheet" href="../../assets/css/carreras.css">
  <link rel="stylesheet" href="../../assets/css/section-titles.css">'
            $content = $content -replace $cssPattern, $cssReplacement
        }
        
        # Reemplazar el título "Perfil de Ingreso" por la imagen
        $perfilIngresoPattern = '<h3 class="carrera-section-title">Perfil de Ingreso</h3>'
        $perfilIngresoReplacement = '<div class="carrera-section-title-container">
            <img src="' + $perfilIngresoImg + '" alt="Perfil de Ingreso" class="section-title-image">
          </div>'
        $content = $content -replace $perfilIngresoPattern, $perfilIngresoReplacement
        
        # Reemplazar el título "Perfil de Egreso" por la imagen
        $perfilEgresoPattern = '<h3 class="carrera-section-title">Perfil de Egreso</h3>'
        $perfilEgresoReplacement = '<div class="carrera-section-title-container">
            <img src="' + $perfilEgresoImg + '" alt="Perfil de Egreso" class="section-title-image">
          </div>'
        $content = $content -replace $perfilEgresoPattern, $perfilEgresoReplacement
        
        # Reemplazar el título "Campo Laboral" por la imagen
        $campoLaboralPattern = '<h3 class="carrera-section-title">Campo Laboral</h3>'
        $campoLaboralReplacement = '<div class="carrera-section-title-container">
            <img src="' + $campoLaboralImg + '" alt="Campo Laboral" class="section-title-image">
          </div>'
        $content = $content -replace $campoLaboralPattern, $campoLaboralReplacement
        
        # Guardar el archivo solo si se hicieron cambios
        if ($content -ne $originalContent) {
            Set-Content -Path $htmlFile -Value $content
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
