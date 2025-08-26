$careerPages = Get-ChildItem -Path "c:\Pagina UPBC\upbc-web\carreras" -Recurse -Filter "*.html"

foreach ($page in $careerPages) {
    $content = Get-Content -Path $page.FullName -Raw
    
    # Reemplazar la información de contacto
    $oldContactInfo = '<li><i class="fa fa-map-marker"></i> Calle Universidad 1000, Mexicali, B.C.</li>
            <li><i class="fa fa-phone"></i> (686) 123-4567</li>
            <li><i class="fa fa-envelope"></i> info@upbc.edu.mx</li>'
    
    $newContactInfo = '<li><i class="fa fa-map-marker"></i> Calle de la Claridad S/N Colonia Plutarco Elías Calles, Mexicali, Baja California, México CP. 21376</li>
            <li><i class="fa fa-phone"></i> (686) 104-2727</li>
            <li><i class="fa fa-envelope"></i> contacto@upbc.edu.mx</li>'
    
    $updatedContent = $content -replace [regex]::Escape($oldContactInfo), $newContactInfo
    
    # Guardar el archivo actualizado
    Set-Content -Path $page.FullName -Value $updatedContent
    
    Write-Host "Actualizado: $($page.FullName)"
}

Write-Host "Actualización completada."
