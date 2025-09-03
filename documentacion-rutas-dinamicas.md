# Documentación del Sistema de Rutas Dinámicas

## Descripción General

El sistema de rutas dinámicas implementado en el sitio web de la UPBC permite que los componentes cargados dinámicamente (navbar, footer, etc.) funcionen correctamente independientemente de la profundidad del directorio en el que se encuentre la página que los carga.

## Problema Resuelto

Anteriormente, las páginas ubicadas en subdirectorios (como `/carreras/animacion/animacion.html`) tenían problemas para cargar correctamente los recursos (CSS, JS, imágenes) referenciados en los componentes dinámicos, ya que las rutas relativas no se ajustaban según la profundidad del directorio. Además, cada subdirectorio tenía su propia copia del archivo `components-loader.js` con rutas hardcodeadas, lo que dificultaba el mantenimiento.

## Solución Implementada

### 1. Sistema Centralizado de Carga de Componentes

Se ha implementado un único archivo `components-loader.js` en la raíz del proyecto que es referenciado por todas las páginas HTML. Este archivo detecta automáticamente la profundidad del directorio y ajusta las rutas en consecuencia.

### 2. Detección Inteligente de Profundidad del Directorio

El archivo `components-loader.js` incluye una función mejorada para detectar la profundidad del directorio:

```javascript
// Función para determinar la ruta base según la ubicación actual
function getBasePath() {
    const path = window.location.pathname;
    console.log('Ruta actual completa:', path);
    
    // Detectar si estamos en un servidor local o en un entorno de producción
    const isLocalhost = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
    console.log('¿Es localhost?', isLocalhost);
    
    // Extraer la parte relevante de la ruta para calcular la profundidad
    let processedPath = path;
    
    // En localhost, necesitamos manejar la ruta de manera diferente
    if (isLocalhost) {
        // Si la ruta contiene '/carreras/', '/universidad/', etc., extraemos desde ahí
        const sections = ['carreras', 'universidad', 'oferta-educativa', 'servicios', 'becas', 'vida-universitaria', 'historia', 'mision-vision'];
        
        for (const section of sections) {
            if (path.includes('/' + section + '/')) {
                const sectionIndex = path.indexOf('/' + section + '/');
                processedPath = path.substring(sectionIndex);
                console.log('Ruta procesada para localhost:', processedPath);
                break;
            }
        }
    }
    
    const parts = processedPath.split('/');
    console.log('Partes de la ruta procesada:', parts);
    
    // Eliminar elementos vacíos y el archivo HTML del final si existe
    const filteredParts = parts.filter(part => part.length > 0);
    console.log('Partes filtradas:', filteredParts);
    
    if (filteredParts.length > 0 && filteredParts[filteredParts.length - 1].includes('.html')) {
        console.log('Eliminando archivo HTML:', filteredParts[filteredParts.length - 1]);
        filteredParts.pop();
    }
    
    // Calcular la profundidad basada en las partes filtradas
    const depth = filteredParts.length;
    console.log('Profundidad calculada:', depth);
    
    // Si estamos en la raíz, no necesitamos prefijo
    if (depth === 0) {
        console.log('En la raíz, no se necesita prefijo');
        return '';
    }
    
    // Construir el prefijo con '../' según la profundidad
    let prefix = '';
    for (let i = 0; i < depth; i++) {
        prefix += '../';
    }
    console.log('Prefijo construido:', prefix);
    
    return prefix;
}
```

### 3. Carga Inteligente de Componentes

El sistema utiliza la ruta base detectada para cargar correctamente los componentes navbar y footer:

```javascript
// Cargar el navbar
console.log('Construyendo ruta para navbar con basePath:', basePath);
const navbarPath = basePath + 'components/navbar.html';
console.log('Ruta final del navbar:', navbarPath);
loadComponent(navbarPath, 'navbar-container')
    .then(() => {
        // Reinicializar funcionalidades del navbar después de cargarlo
        reinitializeNavbarFunctions();
    });

// Cargar el footer
console.log('Construyendo ruta para footer con basePath:', basePath);
const footerPath = basePath + 'components/footer.html';
console.log('Ruta final del footer:', footerPath);
loadComponent(footerPath, 'footer-container')
    .then(() => {
        // Reinicializar funcionalidades del footer después de cargarlo
        reinitializeFooterFunctions();
    });
```

### 4. Corrección de Rutas Relativas y Manejo del Marcador BASE_PATH

Una vez cargado el componente, se corrigen las rutas relativas dentro del mismo y se reemplazan los marcadores `BASE_PATH` por la ruta base calculada:

```javascript
// Función para corregir rutas relativas en los componentes cargados
function fixRelativePaths(element, componentUrl, basePath) {
    console.log('Corrigiendo rutas con basePath:', basePath);
    
    // Corregir rutas en imágenes
    element.querySelectorAll('img').forEach(img => {
        const src = img.getAttribute('src');
        if (src && src.startsWith('assets/')) {
            img.setAttribute('src', basePath + src);
            console.log('Imagen corregida:', src, '->', basePath + src);
        }
    });
    
    // Corregir rutas en enlaces
    element.querySelectorAll('a').forEach(a => {
        const href = a.getAttribute('href');
        if (href && !href.startsWith('http') && !href.startsWith('#') && !href.startsWith('javascript')) {
            // Enlaces a la página principal
            if (href === 'index.html') {
                a.setAttribute('href', basePath + href);
                console.log('Enlace corregido:', href, '->', basePath + href);
            } 
            // Enlaces a recursos estáticos
            else if (href.startsWith('assets/')) {
                a.setAttribute('href', basePath + href);
                console.log('Enlace a recurso corregido:', href, '->', basePath + href);
            }
            // Enlaces a otras páginas
            else if (href.endsWith('.html')) {
                a.setAttribute('href', basePath + href);
                console.log('Enlace a página corregido:', href, '->', basePath + href);
            }
        }
    });
    
    // Corregir rutas en hojas de estilo
    element.querySelectorAll('link[rel="stylesheet"]').forEach(link => {
        const href = link.getAttribute('href');
        if (href) {
            if (href.startsWith('assets/')) {
                link.setAttribute('href', basePath + href);
                console.log('CSS corregido:', href, '->', basePath + href);
            } else if (href.includes('BASE_PATH')) {
                const newHref = href.replace('BASE_PATH', basePath.endsWith('/') ? basePath.slice(0, -1) : basePath);
                link.setAttribute('href', newHref);
                console.log('CSS con BASE_PATH corregido:', href, '->', newHref);
            }
        }
    });
    
    // Reemplazar el marcador BASE_PATH en elementos con clase dynamic-path
    element.querySelectorAll('.dynamic-path').forEach(el => {
        const attr = el.tagName === 'LINK' ? 'href' : (el.tagName === 'IMG' ? 'src' : 'href');
        const value = el.getAttribute(attr);
        if (value && value.includes('BASE_PATH')) {
            const newValue = value.replace('BASE_PATH', basePath.endsWith('/') ? basePath.slice(0, -1) : basePath);
            el.setAttribute(attr, newValue);
            console.log('Elemento dynamic-path corregido:', value, '->', newValue);
        }
    });
}
```

## Cómo Funciona

1. La página HTML incluye el script `components-loader.js` con la ruta relativa correcta (ej: `../../components-loader.js` para páginas en subdirectorios de segundo nivel).
2. Al cargar la página, `components-loader.js` detecta automáticamente la profundidad del directorio.
3. Utiliza esta información para construir las rutas correctas a los componentes navbar y footer.
4. Carga los componentes y corrige las rutas relativas dentro de ellos.
5. Reinicializa las funcionalidades JavaScript necesarias para los componentes.

## Uso del Marcador BASE_PATH

El sistema de rutas dinámicas incluye un marcador especial `BASE_PATH` que se puede utilizar en los componentes para referenciar recursos desde la raíz del proyecto, independientemente de la profundidad del directorio.

### Cómo Usar BASE_PATH

1. **En hojas de estilo:**
   ```html
   <link rel="stylesheet" href="BASE_PATH/assets/css/components/mobile-menu.css" class="dynamic-path">
   ```

2. **En imágenes:**
   ```html
   <img src="BASE_PATH/assets/images/logos/logo.png" alt="Logo" class="dynamic-path">
   ```

3. **En enlaces:**
   ```html
   <a href="BASE_PATH/index.html" class="dynamic-path">Inicio</a>
   ```

### Reglas Importantes

1. **Agregar la clase `dynamic-path`:** Todos los elementos que utilicen el marcador `BASE_PATH` deben tener la clase `dynamic-path` para que el sistema los identifique y procese correctamente.

2. **Formato correcto:** Usar `BASE_PATH` (sin barra al final) seguido de la ruta relativa desde la raíz del proyecto.

3. **Consistencia:** Utilizar el marcador `BASE_PATH` para todas las rutas que necesiten ser relativas a la raíz del proyecto, especialmente en componentes compartidos.

### Ejemplo Completo

```html
<!-- Componente navbar.html -->
<link rel="stylesheet" href="BASE_PATH/assets/css/components/mobile-menu.css" class="dynamic-path">

<nav>
  <a href="BASE_PATH/index.html" class="dynamic-path">
    <img src="BASE_PATH/assets/images/logos/logo.png" alt="Logo" class="dynamic-path">
  </a>
  <ul>
    <li><a href="BASE_PATH/servicios/biblioteca/biblioteca.html" class="dynamic-path">Biblioteca</a></li>
  </ul>
</nav>
```

## Mantenimiento y Extensión

### Añadir Nuevos Componentes

Para añadir un nuevo componente que utilice el sistema de rutas dinámicas:

1. Crear el archivo HTML del componente en la carpeta `/components/`.
2. Utilizar el marcador `BASE_PATH` para todas las rutas relativas dentro del componente y agregar la clase `dynamic-path` a esos elementos.
3. Modificar `components-loader.js` para cargar el nuevo componente si es necesario.

### Modificar Páginas Existentes

Al crear o modificar páginas HTML:

1. Asegurarse de que la página incluya el script `components-loader.js` con la ruta relativa correcta.
2. Incluir los contenedores necesarios para los componentes (por ejemplo, `<div id="navbar-container"></div>`).
3. No crear copias locales de `components-loader.js` en subdirectorios.

## Script de Actualización

Se ha creado un script PowerShell (`update_components_loader_references.ps1`) que actualiza todas las páginas HTML para que usen el archivo `components-loader.js` principal y elimina las versiones locales en subdirectorios:

```powershell
# Script para actualizar todas las páginas HTML para que usen el components-loader.js principal
# y eliminar las versiones locales de components-loader.js en subdirectorios

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

# Actualizar referencias a components-loader.js en archivos HTML
foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Path $htmlFile.FullName -Raw -Encoding UTF8
    $relativePath = Get-RelativePath -htmlFilePath $htmlFile.DirectoryName
    
    # Buscar referencias a components-loader.js locales
    if ($content -match '<script src="components-loader\.js"></script>' -or 
        $content -match '<script src="\.\.\/components-loader\.js"></script>' -or 
        $content -match '<script src="\.\.\/\.\.\/components-loader\.js"></script>') {
        
        # Reemplazar referencias locales con la ruta relativa correcta
        $updatedContent = $content -replace '<script src="components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        $updatedContent = $updatedContent -replace '<script src="\.\.\/components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        $updatedContent = $updatedContent -replace '<script src="\.\.\/\.\.\/components-loader\.js"></script>', "<script src=\"$($relativePath)components-loader.js\"></script>"
        
        # Guardar el archivo actualizado
        Set-Content -Path $htmlFile.FullName -Value $updatedContent -Encoding UTF8
    }
}

# Eliminar versiones locales de components-loader.js
$componentLoaderFiles = Get-ChildItem -Path $rootDir -Filter "components-loader.js" -Recurse | 
    Where-Object { $_.DirectoryName -ne $rootDir -and $_.DirectoryName -ne "$rootDir\assets\js" }

foreach ($file in $componentLoaderFiles) {
    Remove-Item -Path $file.FullName -Force
}
```

## Consideraciones Importantes

- Este sistema funciona para recursos internos del sitio web, no para enlaces externos.
- El sistema incluye logs detallados para facilitar la depuración en caso de problemas con las rutas.
- Se ha implementado una detección especial para entornos locales (localhost) que ajusta la profundidad calculada.
- El sistema depende de la estructura de directorios del sitio web, por lo que cambios en esta estructura podrían requerir ajustes en la lógica de detección de profundidad.

## Ejemplo de Uso

### En una página HTML en la raíz:
```html
<!-- Incluir el script components-loader.js -->
<script src="components-loader.js"></script>

<!-- Contenedores para los componentes -->
<div id="navbar-container"></div>
<div id="footer-container"></div>
```

### En una página HTML en un subdirectorio (por ejemplo, /carreras/animacion/):
```html
<!-- Incluir el script components-loader.js con la ruta relativa correcta -->
<script src="../../components-loader.js"></script>

<!-- Contenedores para los componentes -->
<div id="navbar-container"></div>
<div id="footer-container"></div>
```

### En el archivo components-loader.js:
```javascript
document.addEventListener('DOMContentLoaded', function() {
    // Determinar la ruta base para corregir rutas relativas
    const basePath = getBasePath();
    console.log('Ruta base detectada:', basePath);
    
    // Cargar el navbar
    console.log('Construyendo ruta para navbar con basePath:', basePath);
    const navbarPath = basePath + 'components/navbar.html';
    console.log('Ruta final del navbar:', navbarPath);
    loadComponent(navbarPath, 'navbar-container')
        .then(() => {
            // Reinicializar funcionalidades del navbar después de cargarlo
            reinitializeNavbarFunctions();
        });
    
    // Cargar el footer
    console.log('Construyendo ruta para footer con basePath:', basePath);
    const footerPath = basePath + 'components/footer.html';
    console.log('Ruta final del footer:', footerPath);
    loadComponent(footerPath, 'footer-container')
        .then(() => {
            // Reinicializar funcionalidades del footer después de cargarlo
            reinitializeFooterFunctions();
        });
});
```

## Conclusión

El sistema de rutas dinámicas implementado resuelve eficazmente el problema de las rutas relativas en componentes cargados dinámicamente, independientemente de la profundidad del directorio en el que se encuentre la página. La centralización del archivo `components-loader.js` facilita el mantenimiento y asegura la consistencia en todo el sitio web.
