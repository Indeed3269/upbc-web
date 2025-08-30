# Script para actualizar el footer en todas las páginas de carreras
# Este script reemplaza el footer actual por el componente unificado

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

# Leer el contenido del componente footer
$footerContent = Get-Content -Path ".\components\footer.html" -Raw

# Leer el contenido de los estilos del footer del index.html
$indexContent = Get-Content -Path ".\index.html" -Raw
$footerStylesPattern = '(?s)<!-- Estilos adicionales para el footer -->\s*<style>(.*?)</style>'
$footerStyles = [regex]::Match($indexContent, $footerStylesPattern).Groups[1].Value

foreach ($folder in $careerFolders) {
    $htmlFile = ".\carreras\$folder\$folder.html"
    
    if (Test-Path $htmlFile) {
        Write-Host "Procesando $htmlFile..."
        
        # Leer el contenido del archivo HTML
        $content = Get-Content $htmlFile -Raw
        
        # Reemplazar el footer existente
        $newContent = $content -replace '(?s)<!-- \*\*\*\*\* Footer Start \*\*\*\*\* -->.*?<!-- \*\*\*\*\* Footer End \*\*\*\*\* -->', "<!-- ***** Footer Start ***** -->
$footerContent
<!-- ***** Footer End ***** -->"
        
        # Reemplazar los estilos del footer
        $newContent = $newContent -replace '(?s)<!-- Estilos adicionales para el footer -->\s*<style>.*?</style>', "<!-- Estilos adicionales para el footer -->
<style>$footerStyles</style>"
        
        # Corregir las rutas de las imágenes en el footer
        $newContent = $newContent -replace 'src="assets/images/', 'src="../../assets/images/'
        
        # Guardar el archivo modificado
        Set-Content -Path $htmlFile -Value $newContent -Encoding UTF8
        Write-Host "  - Footer actualizado exitosamente"
    } else {
        Write-Host "El archivo $htmlFile no existe, omitiendo..."
    }
}

Write-Host "Proceso completado. Todas las páginas de carreras han sido actualizadas con el footer unificado."
