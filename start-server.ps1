# Script para iniciar un servidor web simple para probar el sitio
# Este script utiliza el módulo HttpListener de PowerShell para crear un servidor web básico

$port = 8080
$url = "http://localhost:$port/"
$rootPath = $PSScriptRoot

Write-Host "Iniciando servidor web en $url"
Write-Host "Directorio raíz: $rootPath"
Write-Host "Presiona Ctrl+C para detener el servidor"

# Crear un objeto HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

Write-Host "Servidor iniciado. Abriendo navegador..."
Start-Process $url

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Obtener la ruta del archivo solicitado
        $requestedFile = $request.Url.LocalPath.TrimStart('/')
        if ($requestedFile -eq "") {
            $requestedFile = "index.html"
        }
        
        $filePath = Join-Path -Path $rootPath -ChildPath $requestedFile
        
        # Verificar si el archivo existe
        if (Test-Path -Path $filePath -PathType Leaf) {
            # Determinar el tipo MIME
            $contentType = "text/plain"
            switch ([System.IO.Path]::GetExtension($filePath)) {
                ".html" { $contentType = "text/html" }
                ".css"  { $contentType = "text/css" }
                ".js"   { $contentType = "application/javascript" }
                ".jpg"  { $contentType = "image/jpeg" }
                ".jpeg" { $contentType = "image/jpeg" }
                ".png"  { $contentType = "image/png" }
                ".gif"  { $contentType = "image/gif" }
                ".svg"  { $contentType = "image/svg+xml" }
                ".ico"  { $contentType = "image/x-icon" }
                ".json" { $contentType = "application/json" }
                ".woff" { $contentType = "font/woff" }
                ".woff2" { $contentType = "font/woff2" }
                ".ttf"  { $contentType = "font/ttf" }
                ".otf"  { $contentType = "font/otf" }
                ".eot"  { $contentType = "application/vnd.ms-fontobject" }
            }
            
            # Leer el contenido del archivo
            $content = [System.IO.File]::ReadAllBytes($filePath)
            
            # Configurar la respuesta
            $response.ContentType = $contentType
            $response.ContentLength64 = $content.Length
            $response.StatusCode = 200
            
            # Enviar la respuesta
            $output = $response.OutputStream
            $output.Write($content, 0, $content.Length)
            $output.Close()
            
            Write-Host "200 OK: $requestedFile ($contentType)"
        }
        else {
            # Archivo no encontrado
            $response.StatusCode = 404
            $response.Close()
            Write-Host "404 Not Found: $requestedFile"
        }
    }
}
finally {
    # Detener el listener cuando se presiona Ctrl+C
    $listener.Stop()
    Write-Host "Servidor detenido."
}
