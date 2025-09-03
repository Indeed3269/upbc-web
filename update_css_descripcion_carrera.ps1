# Script para añadir la referencia al CSS de corrección de imágenes de descripción de carrera
# en todas las páginas de carreras

$carrerasDir = ".\carreras"
$carrerasFolders = Get-ChildItem -Path $carrerasDir -Directory

foreach ($folder in $carrerasFolders) {
    $htmlFile = Join-Path -Path $folder.FullName -ChildPath "$($folder.Name).html"
    
    if (Test-Path $htmlFile) {
        Write-Host "Procesando: $htmlFile"
        
        $content = Get-Content -Path $htmlFile -Raw -Encoding UTF8
        
        # Buscar la línea de referencia a carrera-info-fix.css y añadir la nueva línea después
        if ($content -match '(.*<link rel="stylesheet" href="../../assets/css/components/carrera-info-fix.css">)(.*)') {
            $newContent = $content -replace '(<link rel="stylesheet" href="../../assets/css/components/carrera-info-fix.css">)', '$1
  <link rel="stylesheet" href="../../assets/css/components/descripcion-carrera-fix.css">'
            
            # Guardar el archivo con la nueva referencia CSS
            $newContent | Out-File -FilePath $htmlFile -Encoding UTF8
            Write-Host "  - Referencia CSS añadida correctamente" -ForegroundColor Green
        } else {
            # Si no encuentra la línea específica, buscar la sección de CSS y añadir después de la última
            if ($content -match '(.*<link rel="stylesheet" href="../../assets/css/[^"]+\.css[^"]*">)([^<]*<link[^>]*>)*(.*)') {
                $newContent = $content -replace '(<link rel="stylesheet" href="../../assets/css/[^"]+\.css[^"]*">)([^<]*<link[^>]*>)*([^<]*<style|[^<]*<script|[^<]*<\/head>)', '$1$2
  <link rel="stylesheet" href="../../assets/css/components/descripcion-carrera-fix.css">$3'
                
                # Guardar el archivo con la nueva referencia CSS
                $newContent | Out-File -FilePath $htmlFile -Encoding UTF8
                Write-Host "  - Referencia CSS añadida después del último CSS" -ForegroundColor Green
            } else {
                Write-Host "  - No se pudo encontrar un lugar adecuado para insertar la referencia CSS" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Archivo no encontrado: $htmlFile" -ForegroundColor Yellow
    }
}

Write-Host "`nProceso completado. Revise las páginas para verificar que las imágenes se muestren correctamente." -ForegroundColor Cyan
