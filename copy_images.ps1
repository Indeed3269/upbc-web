# Script para copiar imágenes con nombres que contienen caracteres especiales

# Copiar imágenes de descripción de carreras
$sourceDir = "Nueva imagen carreras-TSU _ Mapas curricular\CORTADOS Y BOTONES"

# Administración
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_ADMINISTRACION-01.jpg" -Destination "assets\images\carreras\administracion\descripcion.jpg" -Force
Write-Host "Copiada imagen de Administración" -ForegroundColor Green

# Animación
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_ANIMACION-01.jpg" -Destination "assets\images\carreras\animacion\descripcion.jpg" -Force
Write-Host "Copiada imagen de Animación" -ForegroundColor Green

# Educación
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_EDUCACION-01.jpg" -Destination "assets\images\carreras\educacion\descripcion.jpg" -Force
Write-Host "Copiada imagen de Educación" -ForegroundColor Green

# Energía
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_ENERGIA-01.jpg" -Destination "assets\images\carreras\energia\descripcion.jpg" -Force
Write-Host "Copiada imagen de Energía" -ForegroundColor Green

# Gastronomía
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_GASTRONOMIA-01.jpg" -Destination "assets\images\carreras\gastronomia\descripcion.jpg" -Force
Write-Host "Copiada imagen de Gastronomía" -ForegroundColor Green

# Industrial
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_INDUSTRIAL-01.jpg" -Destination "assets\images\carreras\industrial\descripcion.jpg" -Force
Write-Host "Copiada imagen de Industrial" -ForegroundColor Green

# Manufactura
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_MANUFACTURA-01.jpg" -Destination "assets\images\carreras\manufactura\descripcion.jpg" -Force
Write-Host "Copiada imagen de Manufactura" -ForegroundColor Green

# Mecatrónica
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_MECATRONICA-01.jpg" -Destination "assets\images\carreras\mecatronica\descripcion.jpg" -Force
Write-Host "Copiada imagen de Mecatrónica" -ForegroundColor Green

# Negocios y Mercadotecnia
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_NEGOCIOSyMERCADOTECNIA-01.jpg" -Destination "assets\images\carreras\negocios\descripcion.jpg" -Force
Write-Host "Copiada imagen de Negocios y Mercadotecnia" -ForegroundColor Green

# Semiconductores
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_SEMICONDUCTORES-01.jpg" -Destination "assets\images\carreras\microelectronica\descripcion.jpg" -Force
Write-Host "Copiada imagen de Semiconductores" -ForegroundColor Green

# Tecnologías de la Información
Copy-Item -LiteralPath "$sourceDir\UPBC_Descripcióndecarrera_TI-01.jpg" -Destination "assets\images\carreras\tecnologias\descripcion.jpg" -Force
Write-Host "Copiada imagen de Tecnologías de la Información" -ForegroundColor Green

# Copiar imágenes de títulos
$titleDir = "assets\images\carreras\titles"
if (-not (Test-Path $titleDir)) {
    New-Item -Path $titleDir -ItemType Directory | Out-Null
    Write-Host "Creado directorio para imágenes de títulos: $titleDir" -ForegroundColor Green
}

Copy-Item -LiteralPath "$sourceDir\UPBC_PAGWEB_Campolaboral.png" -Destination "$titleDir\campo-laboral.png" -Force
Write-Host "Copiada imagen de título: Campo Laboral" -ForegroundColor Green

Copy-Item -LiteralPath "$sourceDir\UPBC_PAGWEB_PerfildeEgreso.png" -Destination "$titleDir\perfil-egreso.png" -Force
Write-Host "Copiada imagen de título: Perfil de Egreso" -ForegroundColor Green

Copy-Item -LiteralPath "$sourceDir\UPBC_PAGWEB_PerfildeIngreso.png" -Destination "$titleDir\perfil-ingreso.png" -Force
Write-Host "Copiada imagen de título: Perfil de Ingreso" -ForegroundColor Green

Write-Host "`nProceso completado. Todas las imágenes han sido copiadas." -ForegroundColor Cyan
