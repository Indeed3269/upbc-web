# Script para actualizar todas las páginas de carreras con el nuevo archivo CSS
# Este script añade el enlace al nuevo archivo CSS en todas las páginas de carreras

$careerFolders = @(
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

$cssLink = '  <link rel="stylesheet" href="../../assets/css/components/carrera-info-fix.css">'
$insertAfter = '  <link rel="stylesheet" href="../../assets/css/section-titles.css">'

foreach ($folder in $careerFolders) {
    $htmlFile = ".\carreras\$folder\$folder.html"
    
    if (Test-Path $htmlFile) {
        Write-Host "Procesando $htmlFile..."
        
        $content = Get-Content $htmlFile -Encoding UTF8
        $newContent = @()
        $cssAdded = $false
        
        foreach ($line in $content) {
            $newContent += $line
            
            # Si encontramos la línea después de la cual queremos insertar el nuevo CSS
            if ($line -match [regex]::Escape($insertAfter) -and -not $cssAdded) {
                $newContent += $cssLink
                $cssAdded = $true
                Write-Host "  - CSS añadido"
            }
        }
        
        if ($cssAdded) {
            Set-Content -Path $htmlFile -Value $newContent -Encoding UTF8
            Write-Host "  - Archivo actualizado exitosamente"
        } else {
            Write-Host "  - No se pudo encontrar el punto de inserción en el archivo"
        }
    } else {
        Write-Host "El archivo $htmlFile no existe, omitiendo..."
    }
}

Write-Host "Proceso completado. Todas las páginas de carreras han sido actualizadas."
