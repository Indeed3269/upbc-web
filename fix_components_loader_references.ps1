# Script para corregir las referencias a components-loader.js en todas las páginas de carreras
# Este script estandariza todas las referencias para que apunten al archivo components-loader.js en la raíz

$rootDir = $PSScriptRoot
Write-Host "Directorio raíz: $rootDir"

# Función para procesar archivos HTML
function Process-HtmlFile {
    param (
        [string]$filePath
    )
    
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Reemplazar referencias a assets/js/components-loader.js con components-loader.js
    $pattern1 = '(<script\s+src=")([^"]*?)assets/js/components-loader\.js(".*?>)'
    $replacement1 = '$1$2components-loader.js$3'
    $content = $content -replace $pattern1, $replacement1
    
    # Si el contenido ha cambiado, guardar el archivo
    if ($content -ne $originalContent) {
        Write-Host "Actualizando referencias en: $filePath"
        $content | Set-Content -Path $filePath -Encoding UTF8 -NoNewline
        return $true
    }
    
    return $false
}

# Buscar todos los archivos HTML en el directorio de carreras
$carrerasDir = Join-Path -Path $rootDir -ChildPath "carreras"
$htmlFiles = Get-ChildItem -Path $carrerasDir -Filter "*.html" -Recurse

$updatedFiles = 0

foreach ($file in $htmlFiles) {
    $updated = Process-HtmlFile -filePath $file.FullName
    if ($updated) {
        $updatedFiles++
    }
}

Write-Host "Proceso completado. Se actualizaron $updatedFiles archivos HTML."
