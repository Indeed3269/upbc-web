# Script to remove local components-loader.js files from career folders
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

foreach ($folder in $careerFolders) {
    $filePath = ".\carreras\$folder\components-loader.js"
    if (Test-Path $filePath) {
        Write-Host "Removing $filePath"
        Remove-Item $filePath -Force
    } else {
        Write-Host "$filePath does not exist"
    }
}

Write-Host "All local components-loader.js files have been removed."
