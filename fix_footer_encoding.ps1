# Script para corregir problemas de codificación en los footers de las páginas de carreras
# Este script reemplaza los caracteres mal codificados en los footers estáticos

# Lista de directorios de carreras
$careerDirs = @(
    "carreras\administracion",
    "carreras\animacion",
    "carreras\educacion",
    "carreras\energia",
    "carreras\gastronomia",
    "carreras\industrial",
    "carreras\manufactura",
    "carreras\mecatronica",
    "carreras\microelectronica",
    "carreras\tecnologias"
)

# Mapeo de caracteres mal codificados a sus versiones correctas
$replacements = @{
    "PolitÃ©cnica" = "Politécnica"
    "descripciÃ³n" = "descripción"
    "Enlaces Ãºtiles" = "Enlaces útiles"
    "TÃ©rminos" = "Términos"
    "SÃ­guenos" = "Síguenos"
    "LÃ­nea" = "Línea"
}

foreach ($dir in $careerDirs) {
    $htmlFiles = Get-ChildItem -Path $dir -Filter "*.html" -Recurse
    
    foreach ($file in $htmlFiles) {
        Write-Host "Procesando $($file.FullName)..."
        
        # Leer el contenido del archivo
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Realizar reemplazos
        foreach ($key in $replacements.Keys) {
            $content = $content -replace $key, $replacements[$key]
        }
        
        # Guardar el archivo con la codificación correcta
        $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
        
        Write-Host "Archivo $($file.FullName) procesado correctamente."
    }
}

Write-Host "Proceso completado. Se han corregido los problemas de codificación en los footers."
