# Script para actualizar manualmente la información de las carreras

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

# Contador de archivos actualizados
$updatedFiles = 0

# Recorrer cada carpeta de carrera
foreach ($carrera in $carrerasFolders) {
    $htmlFile = "carreras\$carrera\$carrera.html"
    
    if (Test-Path $htmlFile) {
        # Leer el archivo completo
        $lines = Get-Content -Path $htmlFile -Encoding UTF8
        $modified = $false
        
        # Buscar y actualizar las secciones específicas
        for ($i = 0; $i -lt $lines.Count; $i++) {
            # Actualizar título de la carrera
            if ($lines[$i] -match '<h1 class="carrera-title">') {
                switch ($carrera) {
                    "administracion" { $lines[$i] = '          <h1 class="carrera-title">Licenciatura en Administración</h1>' }
                    "animacion" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería en Animación y Efectos Visuales</h1>' }
                    "educacion" { $lines[$i] = '          <h1 class="carrera-title">Licenciatura en Educación</h1>' }
                    "energia" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería en Energía y Desarrollo Sostenible</h1>' }
                    "gastronomia" { $lines[$i] = '          <h1 class="carrera-title">Licenciatura en Gastronomía</h1>' }
                    "industrial" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería Industrial</h1>' }
                    "manufactura" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería en Manufactura Avanzada</h1>' }
                    "mecatronica" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería Mecatrónica</h1>' }
                    "microelectronica" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería en Microelectrónica y Semiconductores</h1>' }
                    "negocios" { $lines[$i] = '          <h1 class="carrera-title">Licenciatura en Negocios y Mercadotecnia</h1>' }
                    "tecnologias" { $lines[$i] = '          <h1 class="carrera-title">Ingeniería en Tecnologías de la Información e Innovación Digital</h1>' }
                }
                $modified = $true
            }
            
            # Actualizar duración
            if ($lines[$i] -match '<h4>Duración</h4>') {
                $lines[$i+1] = '            <p>10 cuatrimestres</p>'
                $modified = $true
            }
            
            # Actualizar modalidad
            if ($lines[$i] -match '<h4>Modalidad</h4>') {
                $lines[$i+1] = '            <p>Presencial</p>'
                $modified = $true
            }
            
            # Actualizar título que otorga
            if ($lines[$i] -match '<h4>Título que otorga</h4>') {
                $lines[$i+1] = '            <p>Técnico Superior Universitario</p>'
                $modified = $true
            }
        }
        
        # Eliminar secciones completas (requisitos de ingreso, software especializado, laboratorios)
        $newLines = @()
        $skipSection = $false
        $sectionToSkip = ""
        
        foreach ($line in $lines) {
            if ($line -match '<h4>Requisitos de ingreso</h4>' -or 
                $line -match '<h4>Software Especializado</h4>' -or 
                $line -match '<h4>Laboratorios especializados</h4>') {
                $skipSection = $true
                $sectionToSkip = $line
                $modified = $true
                continue
            }
            
            if ($skipSection -and $line -match '</div>' -and $line -match 'carrera-info-box') {
                $skipSection = $false
                continue
            }
            
            if (-not $skipSection) {
                $newLines += $line
            }
        }
        
        # Guardar el archivo si se modificó
        if ($modified) {
            Set-Content -Path $htmlFile -Value $newLines -Encoding UTF8
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
