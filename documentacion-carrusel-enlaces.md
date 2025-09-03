# Documentación: Actualización de Enlaces del Carrusel

## Problema Original
El carrusel en la página de inicio mostraba imágenes de las diferentes carreras ofrecidas por la UPBC, pero los enlaces dirigían a una URL externa (https://www.upbc.edu.mx/OfertaEducativa/Carreras25.html) en lugar de a la sección de carreras disponibles en la misma página.

## Solución Implementada
Se modificaron todos los enlaces del carrusel para que dirijan al ancla `#carreras-disponibles` dentro de la misma página, permitiendo a los usuarios acceder directamente a la lista de carreras disponibles al hacer clic en cualquier imagen del carrusel.

### Cambios Realizados
1. Se identificaron todos los elementos `<a>` dentro del carrusel en `index.html`.
2. Se reemplazaron todas las URLs externas por el enlace interno `#carreras-disponibles`.
3. Se mantuvo el atributo `title="Ver oferta educativa"` para preservar la información al pasar el cursor.

### Archivos Modificados
- `index.html` - Se actualizaron los enlaces del carrusel (líneas 421-473)

## Beneficios
1. **Mejor Experiencia de Usuario**: Los visitantes pueden navegar directamente a la sección de carreras sin salir de la página principal.
2. **Mayor Retención**: Se evita que los usuarios abandonen el sitio al ser redirigidos a URLs externas.
3. **Navegación Intuitiva**: La interacción con el carrusel ahora es más coherente con el comportamiento esperado.

## Notas Adicionales
- Esta modificación complementa la solución anterior para las imágenes de descripción de carreras, mejorando la experiencia general del usuario en el sitio.
- La sección de carreras disponibles tiene el ID `carreras-disponibles` que permite el desplazamiento automático al hacer clic en los enlaces.
