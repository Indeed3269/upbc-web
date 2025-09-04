# Solución al Error MIME en microelectronica.html

## Problema Identificado
Se identificó un error MIME en la página `microelectronica.html` relacionado con la carga del archivo CSS `mobile-menu.css`. El error ocurría porque la variable `BASE_PATH` en las rutas CSS no se estaba reemplazando correctamente cuando se cargaba el componente navbar.

## Análisis del Problema
1. **Referencia en navbar.html**: El archivo `navbar.html` incluye una referencia a `mobile-menu.css` usando la variable `BASE_PATH`:
   ```html
   <link rel="stylesheet" href="BASE_PATH/assets/css/components/mobile-menu.css" class="dynamic-path">
   ```

2. **Carga del script**: La página `microelectronica.html` estaba cargando el archivo `components-loader.js` desde la raíz del proyecto:
   ```html
   <script src="../../components-loader.js"></script>
   ```

3. **Función de reemplazo**: La función `fixRelativePaths()` en `components-loader.js` no estaba manejando correctamente el reemplazo de `BASE_PATH` en las etiquetas `<link>` con atributo `href`.

## Solución Implementada

### 1. Creación de una versión local de components-loader.js
Se creó una copia local del archivo `components-loader.js` en la carpeta `carreras/microelectronica/` con la función `fixRelativePaths()` mejorada para manejar correctamente las rutas CSS con `BASE_PATH`:

```javascript
// Corregir rutas en hojas de estilo
element.querySelectorAll('link[rel="stylesheet"]').forEach(link => {
    const href = link.getAttribute('href');
    if (href) {
        if (href.startsWith('assets/')) {
            link.setAttribute('href', basePath + href);
            console.log('CSS corregido:', href, '->', basePath + href);
        } else if (href.includes('BASE_PATH')) {
            // Asegurarse de que basePath no termine con / para evitar doble slash
            const basePathClean = basePath.endsWith('/') ? basePath.slice(0, -1) : basePath;
            const newHref = href.replace(/BASE_PATH\//g, basePathClean + '/').replace(/BASE_PATH/g, basePathClean);
            link.setAttribute('href', newHref);
            console.log('CSS con BASE_PATH corregido:', href, '->', newHref);
        }
    }
});
```

### 2. Actualización de la referencia en microelectronica.html
Se modificó la referencia al script `components-loader.js` en `microelectronica.html` para que use la versión local:

```html
<!-- Antes -->
<script src="../../components-loader.js"></script>

<!-- Después -->
<script src="components-loader.js"></script>
```

## Beneficios de la Solución
1. **Aislamiento**: Al usar una versión local del script, se evitan conflictos con otras versiones del mismo script en el proyecto.
2. **Corrección específica**: La versión local incluye la corrección específica para el manejo de rutas CSS con `BASE_PATH`.
3. **Mejor mantenimiento**: Facilita la identificación y resolución de problemas específicos de la página `microelectronica.html`.

## Recomendaciones para otras páginas
Si se encuentran errores MIME similares en otras páginas de carreras, se recomienda aplicar la misma solución:
1. Crear una copia local de `components-loader.js` en la carpeta de la carrera correspondiente.
2. Actualizar la referencia en el archivo HTML para que apunte a la versión local.

Esta solución garantiza que el archivo `mobile-menu.css` se cargue correctamente desde la ruta adecuada, evitando el error MIME.
