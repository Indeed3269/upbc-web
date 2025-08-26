$pagesToUpdate = @(
    "c:\Pagina UPBC\upbc-web\becas\becas.html",
    "c:\Pagina UPBC\upbc-web\calendario.html",
    "c:\Pagina UPBC\upbc-web\historia\historia.html",
    "c:\Pagina UPBC\upbc-web\mision-vision\mision-vision.html",
    "c:\Pagina UPBC\upbc-web\news-template.html"
)

foreach ($page in $pagesToUpdate) {
    if (Test-Path $page) {
        $content = Get-Content -Path $page -Raw
        
        # Reemplazar la información de contacto
        $oldContactInfo = '<li><i class="fa fa-map-marker"></i> Calle Universidad 1000, Mexicali, B.C.</li>
            <li><i class="fa fa-phone"></i> (686) 123-4567</li>
            <li><i class="fa fa-envelope"></i> info@upbc.edu.mx</li>'
        
        $newContactInfo = '<li><i class="fa fa-map-marker"></i> Calle de la Claridad S/N Colonia Plutarco Elías Calles, Mexicali, Baja California, México CP. 21376</li>
            <li><i class="fa fa-phone"></i> (686) 104-2727</li>
            <li><i class="fa fa-envelope"></i> contacto@upbc.edu.mx</li>'
        
        $updatedContent = $content -replace [regex]::Escape($oldContactInfo), $newContactInfo
        
        # También actualizar la sección de contacto si existe
        $oldContactSection = '<h6>Teléfono</h6>
                <span>+52 (664) 123-4567</span>
              </li>
              <li>
                <h6>Correo Electrónico</h6>
                <span>contacto@upbc.edu.mx</span>
              </li>
              <li>
                <h6>Dirección</h6>
                <span>Carretera Tijuana-Ensenada Km. 10, Zona Playitas, Ensenada, B.C.</span>'
        
        $newContactSection = '<h6>Teléfono</h6>
                <span>(686) 104-2727</span>
              </li>
              <li>
                <h6>Correo Electrónico</h6>
                <span>contacto@upbc.edu.mx</span>
              </li>
              <li>
                <h6>Dirección</h6>
                <span>Calle de la Claridad S/N Colonia Plutarco Elías Calles, Mexicali, Baja California, México CP. 21376</span>'
        
        $updatedContent = $updatedContent -replace [regex]::Escape($oldContactSection), $newContactSection
        
        # Guardar el archivo actualizado
        Set-Content -Path $page -Value $updatedContent
        
        Write-Host "Actualizado: $page"
    } else {
        Write-Host "No se encontró el archivo: $page"
    }
}

Write-Host "Actualización completada."
