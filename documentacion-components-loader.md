# Documentación de Solución: Components-Loader

## Problema Identificado

Se identificaron varios problemas relacionados con el archivo `components-loader.js` en el sitio web de la UPBC:

1. **Inconsistencia en las referencias**: Algunas páginas cargaban el script desde la raíz (`../../components-loader.js`) mientras otras lo hacían desde la carpeta de assets (`../../assets/js/components-loader.js`).

2. **Manejo incorrecto de rutas relativas**: La función `fixRelativePaths()` no procesaba correctamente las rutas CSS que contenían la variable `BASE_PATH`.

3. **Duplicidad de archivos**: Existían dos versiones del archivo `components-loader.js` en el proyecto (una en la raíz y otra en `assets/js`).

4. **Errores 404 y MIME**: Algunas páginas presentaban errores al cargar componentes debido a rutas incorrectas. En particular, se detectó un error MIME en las hojas de estilo que contenían `BASE_PATH` en sus rutas:
   ```
   Refused to apply style from 'http://127.0.0.1:5501/carreras/mecatronica/BASE_PATH/assets/css/components/mobile-menu.css' because its MIME type ('text/html') is not a supported stylesheet MIME type, and strict MIME checking is enabled.
   ```

## Solución Implementada

### 1. Corrección de la función `fixRelativePaths`

Se mejoró la función `fixRelativePaths` en ambas versiones de `components-loader.js` para manejar correctamente las rutas relativas en:

- Imágenes (`img[src]`)
- Enlaces (`a[href]`)
- Hojas de estilo (`link[href]`)
- Otros atributos que contienen el marcador `BASE_PATH`

La función ahora reemplaza correctamente la variable `BASE_PATH` en todas las rutas con la ruta base calculada. Se implementó un manejo especial para evitar problemas con barras diagonales dobles (`//`) en las rutas, asegurando que el reemplazo de `BASE_PATH` sea limpio y correcto:

```javascript
// Asegurarse de que basePath no termine con / para evitar doble slash
const basePathClean = basePath.endsWith('/') ? basePath.slice(0, -1) : basePath;
const newHref = href.replace(/BASE_PATH\//g, basePathClean + '/').replace(/BASE_PATH/g, basePathClean);
```

Esta mejora resuelve el error MIME que ocurría cuando el marcador `BASE_PATH` no se reemplazaba correctamente en las rutas CSS del navbar.

### 2. Estandarización de Referencias

Se creó un script PowerShell (`fix_components_loader_references.ps1`) para estandarizar todas las referencias a `components-loader.js` en las páginas de carreras:

- Se reemplazaron todas las referencias a `assets/js/components-loader.js` con `components-loader.js`
- Se aseguró que todas las páginas utilicen la ruta relativa correcta según su nivel de anidamiento

### 3. Actualización de Ambas Versiones

Se actualizaron ambas versiones del archivo `components-loader.js` para asegurar que tengan la misma funcionalidad:

- La versión en la raíz (`/components-loader.js`)
- La versión en assets (`/assets/js/components-loader.js`)

### 4. Verificación de Rutas en Páginas Clave

Se verificaron manualmente las referencias en páginas clave para asegurar que todas utilicen la ruta correcta:

- Página principal (`index.html`)
- Páginas de noticias (`news-nuevas-carreras.html`)
- Páginas de carreras (todas las carreras)
- Otras páginas importantes del sitio

## Estructura de Carga de Componentes

El sistema de carga de componentes funciona de la siguiente manera:

1. Cada página HTML incluye contenedores para el navbar y footer:
   ```html
   <div id="navbar-container"></div>
   <div id="footer-container"></div>
   ```

2. Al final de cada página se carga el script `components-loader.js` con la ruta relativa correcta:
   ```html
   <script src="../components-loader.js"></script>
   ```

3. El script `components-loader.js` calcula la ruta base (`getBasePath()`) según la profundidad del archivo actual.

4. Luego carga los componentes navbar y footer desde las rutas:
   - `components/navbar.html`
   - `components/footer.html`

5. Finalmente, corrige todas las rutas relativas dentro de los componentes cargados utilizando la función `fixRelativePaths()`.

## Recomendaciones

1. **Mantener una única versión**: Considerar eliminar la versión duplicada de `components-loader.js` en `assets/js` y mantener solo la versión en la raíz.

2. **Ejecutar el script de estandarización**: Ejecutar periódicamente el script `fix_components_loader_references.ps1` después de añadir nuevas páginas para asegurar consistencia.

3. **Verificar nuevas páginas**: Al crear nuevas páginas, asegurarse de incluir la referencia correcta a `components-loader.js` según el nivel de anidamiento.

4. **Monitorear errores 404**: Revisar periódicamente la consola del navegador para detectar posibles errores 404 relacionados con rutas incorrectas.

## Conclusión

La solución implementada resuelve los problemas de carga de componentes en el sitio web de la UPBC, asegurando que todas las páginas carguen correctamente el navbar y footer. La estandarización de las referencias a `components-loader.js` y la mejora en el manejo de rutas relativas garantizan un funcionamiento consistente en todas las secciones del sitio.
