# Script para corregir problemas de codificación en todas las páginas de carreras
# Este script aplica correcciones específicas para caracteres especiales en todas las páginas HTML de carreras

# Definir la ruta base
$basePath = "c:\Pagina UPBC\upbc-web\carreras"

# Obtener todas las páginas HTML de carreras
$careerPages = Get-ChildItem -Path $basePath -Recurse -Filter "*.html"

Write-Host "Encontradas $($careerPages.Count) páginas de carreras para procesar..."

# Contador para seguimiento
$processedCount = 0

foreach ($page in $careerPages) {
    Write-Host "Procesando: $($page.FullName)"
    
    # Leer el contenido del archivo
    $content = Get-Content -Path $page.FullName -Raw -Encoding UTF8
    
    # Reemplazos específicos para metadatos y títulos
    $replacements = @{
        # Metadatos y títulos
        'content="Ingenier\u00c3\u00ada' = 'content="Ingeniería'
        'content="Administraci\u00c3\u00b3n' = 'content="Administración'
        'content="Educaci\u00c3\u00b3n' = 'content="Educación'
        'content="Tecnolog\u00c3\u00adas' = 'content="Tecnologías'
        'content="Gastronom\u00c3\u00ada' = 'content="Gastronomía'
        '<title>Ingenier\u00c3\u00ada' = '<title>Ingeniería'
        '<title>Administraci\u00c3\u00b3n' = '<title>Administración'
        '<title>Educaci\u00c3\u00b3n' = '<title>Educación'
        '<title>Tecnolog\u00c3\u00adas' = '<title>Tecnologías'
        '<title>Gastronom\u00c3\u00ada' = '<title>Gastronomía'
        
        # Caracteres especiales comunes en el contenido
        'Ingenier\u00c3\u00ada' = 'Ingeniería'
        'Administraci\u00c3\u00b3n' = 'Administración'
        'Educaci\u00c3\u00b3n' = 'Educación'
        'Tecnolog\u00c3\u00adas' = 'Tecnologías'
        'Gastronom\u00c3\u00ada' = 'Gastronomía'
        'Animaci\u00c3\u00b3n' = 'Animación'
        'Mecatr\u00c3\u00b3nica' = 'Mecatrónica'
        'Microelectr\u00c3\u00b3nica' = 'Microelectrónica'
        'Energ\u00c3\u00ada' = 'Energía'
        'Electr\u00c3\u00b3nica' = 'Electrónica'
        'Inform\u00c3\u00a1tica' = 'Informática'
        'Autom\u00c3\u00a1tica' = 'Automática'
        'Rob\u00c3\u00b3tica' = 'Robótica'
        'Comunicaci\u00c3\u00b3n' = 'Comunicación'
        'Programaci\u00c3\u00b3n' = 'Programación'
        'Innovaci\u00c3\u00b3n' = 'Innovación'
        'Formaci\u00c3\u00b3n' = 'Formación'
        'Gesti\u00c3\u00b3n' = 'Gestión'
        'Producci\u00c3\u00b3n' = 'Producción'
        'Investigaci\u00c3\u00b3n' = 'Investigación'
        'Aplicaci\u00c3\u00b3n' = 'Aplicación'
        'Integraci\u00c3\u00b3n' = 'Integración'
        'Automatizaci\u00c3\u00b3n' = 'Automatización'
        'Implementaci\u00c3\u00b3n' = 'Implementación'
        'Operaci\u00c3\u00b3n' = 'Operación'
        'Evaluaci\u00c3\u00b3n' = 'Evaluación'
        'Capacitaci\u00c3\u00b3n' = 'Capacitación'
        'Soluci\u00c3\u00b3n' = 'Solución'
        'Optimizaci\u00c3\u00b3n' = 'Optimización'
        'Simulaci\u00c3\u00b3n' = 'Simulación'
        'Planificaci\u00c3\u00b3n' = 'Planificación'
        'Organizaci\u00c3\u00b3n' = 'Organización'
        'Direcci\u00c3\u00b3n' = 'Dirección'
        'Coordinaci\u00c3\u00b3n' = 'Coordinación'
        'Supervisi\u00c3\u00b3n' = 'Supervisión'
        'Instalaci\u00c3\u00b3n' = 'Instalación'
        'Configuraci\u00c3\u00b3n' = 'Configuración'
        'Fabricaci\u00c3\u00b3n' = 'Fabricación'
        'Construcci\u00c3\u00b3n' = 'Construcción'
        'Dise\u00c3\u00b1o' = 'Diseño'
        'T\u00c3\u00a9cnico' = 'Técnico'
        'T\u00c3\u00a9cnica' = 'Técnica'
        'Pr\u00c3\u00a1ctica' = 'Práctica'
        'Pr\u00c3\u00a1ctico' = 'Práctico'
        'Te\u00c3\u00b3rico' = 'Teórico'
        'Te\u00c3\u00b3rica' = 'Teórica'
        'Anal\u00c3\u00adtico' = 'Analítico'
        'Anal\u00c3\u00adtica' = 'Analítica'
        'Cr\u00c3\u00adtico' = 'Crítico'
        'Cr\u00c3\u00adtica' = 'Crítica'
        'Sistem\u00c3\u00a1tico' = 'Sistemático'
        'Sistem\u00c3\u00a1tica' = 'Sistemática'
        'Metodol\u00c3\u00b3gico' = 'Metodológico'
        'Metodol\u00c3\u00b3gica' = 'Metodológica'
        'Acad\u00c3\u00a9mico' = 'Académico'
        'Acad\u00c3\u00a9mica' = 'Académica'
        'Cient\u00c3\u00adfico' = 'Científico'
        'Cient\u00c3\u00adfica' = 'Científica'
        'Tecnol\u00c3\u00b3gico' = 'Tecnológico'
        'Tecnol\u00c3\u00b3gica' = 'Tecnológica'
        'Econ\u00c3\u00b3mico' = 'Económico'
        'Econ\u00c3\u00b3mica' = 'Económica'
        'Pol\u00c3\u00adtico' = 'Político'
        'Pol\u00c3\u00adtica' = 'Política'
        'Social' = 'Social'
        'Cultural' = 'Cultural'
        'Ambiental' = 'Ambiental'
        'Sustentable' = 'Sustentable'
        'Sostenible' = 'Sostenible'
        'Renovable' = 'Renovable'
        'Eficiente' = 'Eficiente'
        'Efectivo' = 'Efectivo'
        'Efectiva' = 'Efectiva'
        'Eficaz' = 'Eficaz'
        'Profesional' = 'Profesional'
        'Laboral' = 'Laboral'
        'Empresarial' = 'Empresarial'
        'Industrial' = 'Industrial'
        'Comercial' = 'Comercial'
        'Financiero' = 'Financiero'
        'Financiera' = 'Financiera'
        'Contable' = 'Contable'
        'Administrativo' = 'Administrativo'
        'Administrativa' = 'Administrativa'
        'Gerencial' = 'Gerencial'
        'Directivo' = 'Directivo'
        'Directiva' = 'Directiva'
        'Ejecutivo' = 'Ejecutivo'
        'Ejecutiva' = 'Ejecutiva'
        'Operativo' = 'Operativo'
        'Operativa' = 'Operativa'
        'T\u00c3\u00adtulo' = 'Título'
        'Duraci\u00c3\u00b3n' = 'Duración'
        'Descripci\u00c3\u00b3n' = 'Descripción'
        'Informaci\u00c3\u00b3n' = 'Información'
        'din\u00c3\u00a1micamente' = 'dinámicamente'
        'est\u00c3\u00a1' = 'está'
        'podr\u00c3\u00a1s' = 'podrás'
        'desempe\u00c3\u00b1arte' = 'desempeñarte'
        'ser\u00c3\u00a1s' = 'serás'
        'art\u00c3\u00adsticos' = 'artísticos'
        'composici\u00c3\u00b3n' = 'composición'
        'teor\u00c3\u00ada' = 'teoría'
        'cinematogr\u00c3\u00a1ficas' = 'cinematográficas'
        '\u00c2\u00bf' = '¿'
        'm\u00c3\u00a1s' = 'más'
        'conceptualizaci\u00c3\u00b3n' = 'conceptualización'
        'iluminaci\u00c3\u00b3n' = 'iluminación'
        'admisi\u00c3\u00b3n' = 'admisión'
    }
    
    # Aplicar todos los reemplazos
    foreach ($key in $replacements.Keys) {
        $content = $content -replace $key, $replacements[$key]
    }
    
    # Guardar el archivo con codificación UTF-8 sin BOM
    $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($page.FullName, $content, $utf8NoBomEncoding)
    
    $processedCount++
    Write-Host "Procesado $processedCount de $($careerPages.Count): $($page.Name)"
}

Write-Host "¡Proceso completado! Se han corregido $processedCount páginas de carreras."
