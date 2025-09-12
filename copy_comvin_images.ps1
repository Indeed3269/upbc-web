$sourceImages = @(
    "C:\Users\TAPIAPC\Downloads\WhatsApp Image 2025-09-03 at 11.39.41 AM (1).jpeg",
    "C:\Users\TAPIAPC\Downloads\WhatsApp Image 2025-09-03 at 11.39.43 AM.jpeg",
    "C:\Users\TAPIAPC\Downloads\WhatsApp Image 2025-09-03 at 11.39.41 AM.jpeg"
)

$destinationFolder = ".\news-reunion-comvin\images\"

# Crear la carpeta de destino si no existe
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder -Force
}

# Copiar cada imagen y renombrarla
$i = 1
foreach ($image in $sourceImages) {
    if (Test-Path $image) {
        $newName = "reunion-comvin-$i.jpeg"
        Copy-Item -Path $image -Destination "$destinationFolder\$newName"
        Write-Host "Imagen copiada como $newName"
        $i++
    } else {
        Write-Host "No se encontró la imagen: $image"
    }
}

Write-Host "Proceso completado."
