# Script para verificar que todos los mapas curriculares existan en las ubicaciones correctas
$carreras = @(
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

$baseDir = "assets\images\carreras"
$totalMaps = 0
$missingMaps = 0

Write-Host "Verificando mapas curriculares..." -ForegroundColor Cyan

foreach ($carrera in $carreras) {
    $carreraDir = Join-Path $baseDir $carrera
    
    # Verificar si existe el directorio de la carrera
    if (-not (Test-Path $carreraDir)) {
        Write-Host "ERROR: No se encontró el directorio para la carrera: $carrera" -ForegroundColor Red
        continue
    }
    
    # Buscar mapas curriculares (tanto el formato antiguo como el nuevo)
    $mapasAntiguos = Get-ChildItem -Path $carreraDir -Filter "mapa-curricular.jpg" -ErrorAction SilentlyContinue
    $mapasNuevos = Get-ChildItem -Path $carreraDir -Filter "mapa-curricular-*.jpg" -ErrorAction SilentlyContinue
    
    $numMapas = $mapasAntiguos.Count + $mapasNuevos.Count
    $totalMaps += $numMapas
    
    if ($numMapas -eq 0) {
        Write-Host "ADVERTENCIA: No se encontraron mapas curriculares para la carrera: $carrera" -ForegroundColor Yellow
        $missingMaps++
    } else {
        Write-Host "Carrera: $carrera - $numMapas mapa(s) curricular(es) encontrado(s)" -ForegroundColor Green
        
        # Listar los mapas encontrados
        foreach ($mapa in $mapasAntiguos) {
            Write-Host "  - $($mapa.Name)" -ForegroundColor Gray
        }
        foreach ($mapa in $mapasNuevos) {
            Write-Host "  - $($mapa.Name)" -ForegroundColor Gray
        }
    }
}

Write-Host "`nResumen:" -ForegroundColor Cyan
Write-Host "Total de carreras verificadas: $($carreras.Count)" -ForegroundColor White
Write-Host "Total de mapas curriculares encontrados: $totalMaps" -ForegroundColor White
Write-Host "Carreras sin mapas curriculares: $missingMaps" -ForegroundColor White

if ($missingMaps -eq 0) {
    Write-Host "`nVerificación completada con éxito. Todos los mapas curriculares están presentes." -ForegroundColor Green
} else {
    Write-Host "`nVerificación completada con advertencias. Revise las carreras sin mapas curriculares." -ForegroundColor Yellow
}
