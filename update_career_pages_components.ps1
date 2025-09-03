# Script para actualizar todas las páginas de carreras con componentes dinámicos
# Este script reemplaza los navbars y footers estáticos por contenedores dinámicos

# Función para verificar si un archivo ya tiene el componente dinámico
function Has-DynamicComponent {
    param (
        [string]$FilePath,
        [string]$ComponentId
    )
    
    $content = Get-Content -Path $FilePath -Raw
    return $content -match "<div id=`"$ComponentId`"></div>"
}

# Función para agregar el script components-loader.js si no existe
function Add-ComponentsLoader {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Verificar si ya tiene el script
    if ($content -match "components-loader\.js") {
        Write-Host "El archivo $FilePath ya tiene el script components-loader.js"
        return
    }
    
    # Buscar la posición antes de </body>
    $bodyEndIndex = $content.LastIndexOf("</body>")
    
    if ($bodyEndIndex -gt 0) {
        # Insertar el script antes de </body>
        $newContent = $content.Substring(0, $bodyEndIndex) + 
                     "`n  <!-- Script para cargar componentes dinámicos -->`n  <script src=`"../../assets/js/components-loader.js`"></script>`n" + 
                     $content.Substring($bodyEndIndex)
        
        # Guardar el archivo
        $newContent | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        Write-Host "Se agregó el script components-loader.js a $FilePath"
    }
    else {
        Write-Host "No se pudo encontrar la etiqueta </body> en $FilePath"
    }
}

# Función para reemplazar el navbar estático por un contenedor dinámico
function Replace-Navbar {
    param (
        [string]$FilePath
    )
    
    # Verificar si ya tiene el contenedor dinámico
    if (Has-DynamicComponent -FilePath $FilePath -ComponentId "navbar-container") {
        Write-Host "El archivo $FilePath ya tiene el navbar dinámico"
        return
    }
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Buscar el patrón del navbar estático
    $navbarStartPattern = "<!-- \*\*\*\*\* Header Area Start \*\*\*\*\* -->"
    $navbarEndPattern = "<!-- \*\*\*\*\* Header Area End \*\*\*\*\* -->"
    
    $navbarStartIndex = $content.IndexOf($navbarStartPattern)
    $navbarEndIndex = $content.IndexOf($navbarEndPattern)
    
    if ($navbarStartIndex -ge 0 -and $navbarEndIndex -ge 0) {
        # Calcular la posición final del navbar
        $navbarEndIndex = $content.IndexOf("`n", $navbarEndIndex) + 1
        
        # Reemplazar el navbar estático por el contenedor dinámico
        $newContent = $content.Substring(0, $navbarStartIndex) + 
                     "<!-- ***** Header Area Start ***** -->`n  <div id=`"navbar-container`"></div>`n  <!-- ***** Header Area End ***** -->" + 
                     $content.Substring($navbarEndIndex)
        
        # Guardar el archivo
        $newContent | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        Write-Host "Se reemplazó el navbar estático por un contenedor dinámico en $FilePath"
    }
    else {
        Write-Host "No se pudo encontrar el navbar en $FilePath"
    }
}

# Función para reemplazar el footer estático por un contenedor dinámico
function Replace-Footer {
    param (
        [string]$FilePath
    )
    
    # Verificar si ya tiene el contenedor dinámico
    if (Has-DynamicComponent -FilePath $FilePath -ComponentId "footer-container") {
        Write-Host "El archivo $FilePath ya tiene el footer dinámico"
        return
    }
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Buscar el patrón del footer estático
    $footerStartPattern = "<!-- \*\*\*\*\* Footer Start \*\*\*\*\* -->"
    $footerEndPattern = "<!-- \*\*\*\*\* Footer End \*\*\*\*\* -->"
    
    $footerStartIndex = $content.IndexOf($footerStartPattern)
    $footerEndIndex = $content.IndexOf($footerEndPattern)
    
    if ($footerStartIndex -ge 0 -and $footerEndIndex -ge 0) {
        # Calcular la posición final del footer
        $footerEndIndex = $content.IndexOf("`n", $footerEndIndex) + 1
        
        # Reemplazar el footer estático por el contenedor dinámico
        $newContent = $content.Substring(0, $footerStartIndex) + 
                     "<!-- ***** Footer Start ***** -->`n<div id=`"footer-container`"></div>`n<!-- ***** Footer End ***** -->" + 
                     $content.Substring($footerEndIndex)
        
        # Guardar el archivo
        $newContent | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        Write-Host "Se reemplazó el footer estático por un contenedor dinámico en $FilePath"
    }
    else {
        Write-Host "No se pudo encontrar el footer en $FilePath"
    }
}

# Procesar todas las páginas de carreras
$careerPages = Get-ChildItem -Path "carreras" -Filter "*.html" -Recurse

foreach ($page in $careerPages) {
    Write-Host "Procesando $($page.FullName)..."
    
    # Reemplazar el navbar estático por un contenedor dinámico
    Replace-Navbar -FilePath $page.FullName
    
    # Reemplazar el footer estático por un contenedor dinámico
    Replace-Footer -FilePath $page.FullName
    
    # Agregar el script components-loader.js si no existe
    Add-ComponentsLoader -FilePath $page.FullName
    
    Write-Host "Archivo $($page.FullName) procesado correctamente."
}

Write-Host "Proceso completado. Se han actualizado todas las páginas de carreras con componentes dinámicos."
