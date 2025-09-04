# Script para actualizar todas las páginas HTML para que usen el components-loader.js principal
# y estandarizar todas las referencias a components-loader.js

# Directorio raíz del proyecto
$rootDir = $PSScriptRoot

# Función para calcular la ruta relativa desde un archivo HTML hacia la raíz
function Get-RelativePath {
    param (
        [string]$htmlFilePath
    )
    
    # Obtener la ruta relativa desde el archivo HTML hasta la raíz
    $relativePath = ""
    $depth = ($htmlFilePath.Split("\") | Where-Object { $_ -ne "" }).Count - ($rootDir.Split("\") | Where-Object { $_ -ne "" }).Count
    
    for ($i = 0; $i -lt $depth; $i++) {
        $relativePath += "../"
    }
    
    return $relativePath
}

# Encontrar todos los archivos HTML en el proyecto
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse

Write-Host "Actualizando referencias a components-loader.js en archivos HTML..."

foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Path $htmlFile.FullName -Raw -Encoding UTF8
    $relativePath = Get-RelativePath -htmlFilePath $htmlFile.DirectoryName
    
    # Buscar referencias a components-loader.js locales o en assets/js
    if ($content -match '<script src="components-loader\.js"></script>' -or 
        $content -match '<script src="\.\./components-loader\.js"></script>' -or 
        $content -match '<script src="\.\./\.\./components-loader\.js"></script>' -or
        $content -match '<script src=".*assets\/js\/components-loader\.js"></script>') {
        
        Write-Host "Actualizando $($htmlFile.FullName)"
        
        # Reemplazar referencias locales con la ruta relativa correcta
        $updatedContent = $content -replace '<script src="components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        $updatedContent = $updatedContent -replace '<script src="\.\./components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        $updatedContent = $updatedContent -replace '<script src="\.\./\.\./components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        # Reemplazar referencias a assets/js/components-loader.js
        $updatedContent = $updatedContent -replace '<script src="(.*?)assets\/js\/components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        
        # Guardar el archivo actualizado
        Set-Content -Path $htmlFile.FullName -Value $updatedContent -Encoding UTF8
    }
}

Write-Host "Eliminando versiones locales de components-loader.js..."

# Encontrar todas las versiones locales de components-loader.js (excepto la de la raíz)
$componentLoaderFiles = Get-ChildItem -Path $rootDir -Filter "components-loader.js" -Recurse | 
    Where-Object { $_.DirectoryName -ne $rootDir -and $_.DirectoryName -ne "$rootDir\assets\js" }

foreach ($file in $componentLoaderFiles) {
    Write-Host "Eliminando $($file.FullName)"
    Remove-Item -Path $file.FullName -Force
}

Write-Host "Proceso completado. Se estandarizaron las referencias a components-loader.js en todos los archivos HTML."
