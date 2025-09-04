// Función para cargar componentes HTML desde subcarpeta
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
    
    // Cargar el CSS del footer
    const footerCSSPath = basePath + 'assets/css/components/footer.css';
    loadCSS(footerCSSPath);
    
    loadComponent(footerPath, 'footer-container')
        .then(() => {
            // Reinicializar funcionalidades del footer después de cargarlo
            reinitializeFooterFunctions();
        });
    
    // Función para cargar componentes HTML
    function loadComponent(url, targetId) {
        const target = document.getElementById(targetId);
        if (!target) return Promise.resolve();
        
        console.log('Cargando componente desde:', url);
        
        return fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Error al cargar ${url}: ${response.status}`);
                }
                return response.text();
            })
            .then(html => {
                target.innerHTML = html;
                
                // Corregir rutas relativas en los componentes cargados
                fixRelativePaths(target, url, basePath);
                
                // Activar scripts dentro del componente cargado
                const scripts = target.querySelectorAll('script');
                scripts.forEach(script => {
                    const newScript = document.createElement('script');
                    Array.from(script.attributes).forEach(attr => {
                        newScript.setAttribute(attr.name, attr.value);
                    });
                    newScript.textContent = script.textContent;
                    script.parentNode.replaceChild(newScript, script);
                });
                
                // Disparar evento para notificar que el componente se ha cargado
                const event = new CustomEvent('componentLoaded', { detail: { id: targetId } });
                document.dispatchEvent(event);
                
                return target; // Devolver el elemento para encadenar promesas
            })
            .catch(error => {
                console.error('Error cargando componente:', error);
                return null;
            });
    }
    
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
    
    // Función para corregir rutas relativas en componentes cargados
    function fixRelativePaths(element, componentUrl, basePath) {
        console.log('Corrigiendo rutas relativas en componente cargado');
        
        // Obtener la ruta base del componente (sin el nombre del archivo)
        const componentBasePath = componentUrl.substring(0, componentUrl.lastIndexOf('/') + 1);
        console.log('Ruta base del componente:', componentBasePath);
        
        // Corregir rutas relativas en imágenes
        element.querySelectorAll('img').forEach(img => {
            const src = img.getAttribute('src');
            if (src && !src.startsWith('http') && !src.startsWith('/') && !src.startsWith('data:')) {
                const newSrc = basePath + src;
                img.setAttribute('src', newSrc);
                console.log('Imagen corregida:', src, '->', newSrc);
            }
        });
        
        // Corregir rutas relativas en enlaces
        element.querySelectorAll('a').forEach(a => {
            const href = a.getAttribute('href');
            if (href && !href.startsWith('http') && !href.startsWith('/') && !href.startsWith('#') && !href.startsWith('tel:') && !href.startsWith('mailto:')) {
                const newHref = basePath + href;
                a.setAttribute('href', newHref);
                console.log('Enlace corregido:', href, '->', newHref);
            }
        });
        
        // Corregir rutas relativas en estilos CSS inline que contengan url()
        element.querySelectorAll('[style*="url("]').forEach(el => {
            const style = el.getAttribute('style');
            if (style) {
                // Buscar todas las URL en el estilo inline
                const urlRegex = /url\(['"]?([^'")]+)['"]?\)/g;
                let match;
                let newStyle = style;
                
                while ((match = urlRegex.exec(style)) !== null) {
                    const url = match[1];
                    if (!url.startsWith('http') && !url.startsWith('/') && !url.startsWith('data:')) {
                        const newUrl = basePath + url;
                        newStyle = newStyle.replace(url, newUrl);
                        console.log('URL en estilo inline corregida:', url, '->', newUrl);
                    }
                }
                
                if (newStyle !== style) {
                    el.setAttribute('style', newStyle);
                    console.log('Estilo inline con URL corregido');
                }
            }
        });
        
        // Corregir rutas relativas en hojas de estilo
        element.querySelectorAll('link[rel="stylesheet"]').forEach(link => {
            const href = link.getAttribute('href');
            if (href && !href.startsWith('http') && !href.startsWith('/')) {
                const newHref = basePath + href;
                link.setAttribute('href', newHref);
                console.log('Hoja de estilo corregida:', href, '->', newHref);
            }
        });
        
        // Corregir rutas relativas en scripts
        element.querySelectorAll('script[src]').forEach(script => {
            const src = script.getAttribute('src');
            if (src && !src.startsWith('http') && !src.startsWith('/')) {
                const newSrc = basePath + src;
                script.setAttribute('src', newSrc);
                console.log('Script corregido:', src, '->', newSrc);
            }
        });
        
        // Corregir estilos inline que contengan BASE_PATH
        element.querySelectorAll('[style*="BASE_PATH"]').forEach(el => {
            const style = el.getAttribute('style');
            if (style) {
                const newStyle = style.replace(/BASE_PATH/g, basePath.endsWith('/') ? basePath.slice(0, -1) : basePath);
                el.setAttribute('style', newStyle);
                console.log('Estilo inline con BASE_PATH corregido');
            }
        });
        
        // Reemplazar el marcador BASE_PATH en cualquier elemento con atributos que puedan contener rutas
        const attributesToCheck = ['src', 'href', 'data-src', 'data-background', 'poster'];
        attributesToCheck.forEach(attr => {
            element.querySelectorAll(`[${attr}*="BASE_PATH"]`).forEach(el => {
                const value = el.getAttribute(attr);
                if (value) {
                    // Asegurarse de que basePath no termine con / para evitar doble slash
                    const basePathClean = basePath.endsWith('/') ? basePath.slice(0, -1) : basePath;
                    const newValue = value.replace(/BASE_PATH\//g, basePathClean + '/').replace(/BASE_PATH/g, basePathClean);
                    el.setAttribute(attr, newValue);
                    console.log(`Atributo ${attr} corregido:`, value, '->', newValue);
                }
            });
        });
        
        // Reemplazar el marcador BASE_PATH en elementos con clase dynamic-path (mantener para compatibilidad)
        element.querySelectorAll('.dynamic-path').forEach(el => {
            const attr = el.tagName === 'LINK' ? 'href' : (el.tagName === 'IMG' ? 'src' : 'href');
            const value = el.getAttribute(attr);
            if (value && value.includes('BASE_PATH')) {
                const newValue = value.replace(/BASE_PATH/g, basePath.endsWith('/') ? basePath.slice(0, -1) : basePath);
                el.setAttribute(attr, newValue);
                console.log('Elemento dynamic-path corregido:', value, '->', newValue);
            }
        });
}

// Función para reinicializar funcionalidades del footer
function reinitializeFooterFunctions() {
    console.log('Reinicializando funcionalidades del footer');
    // Aquí puedes añadir código para reinicializar cualquier funcionalidad del footer
    // Por ejemplo, inicializar tooltips, popups, etc.
}

// Función para cargar archivos CSS dinámicamente
function loadCSS(href) {
    console.log('Cargando CSS desde:', href);
    // Verificar si el CSS ya está cargado
    const links = document.getElementsByTagName('link');
    for (let i = 0; i < links.length; i++) {
        if (links[i].href === href) {
            console.log('CSS ya cargado:', href);
            return;
        }
    }
    
    // Si no está cargado, crear un nuevo elemento link
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = href;
    document.head.appendChild(link);
    console.log('CSS cargado correctamente:', href);
}

// Función para reinicializar las funcionalidades del navbar
function reinitializeNavbarFunctions() {
    console.log('Inicializando funciones del navbar');
    
    // Calcular la altura exacta del banner morado superior
    var subHeaderHeight = $('.sub-header').outerHeight();
    console.log('Altura del sub-header:', subHeaderHeight);
    
    // Configurar el header para que esté exactamente debajo del banner morado
    $('.header-area').css('top', subHeaderHeight + 'px');
    
    // Detectar si estamos en vista móvil
    var isMobile = window.matchMedia("(max-width: 991px)").matches;
    console.log('Vista móvil detectada:', isMobile);
    
    // Variable para rastrear el estado del menú
    var menuState = {
        activeItem: null
    };
    
    // Función para cerrar todos los submenús
    function closeAllSubmenus() {
        console.log('Cerrando todos los submenús');
        $('.has-sub').removeClass('active');
        $('.sub-menu').hide();
        menuState.activeItem = null;
    }
    
    // Función para cerrar el menú móvil
    function closeMenu() {
        console.log('Cerrando menú móvil');
        $('.menu-trigger').removeClass('active');
        $('.header-area .nav, .single-row-menu').removeClass('active');
        $('.mobile-menu-overlay').removeClass('active');
        $('body').removeClass('menu-open');
        // Ocultar el logo móvil cuando se cierra el menú
        $('.mobile-menu-logo').css('display', 'none');
    }
    
    // Función para abrir el menú móvil
    function openMenu() {
        console.log('Abriendo menú móvil');
        $('.menu-trigger').addClass('active');
        $('.header-area .main-nav .nav').addClass('active');
        $('.single-row-menu').addClass('active');
        $('.mobile-menu-overlay').addClass('active');
        $('body').addClass('menu-open');
        $('.mobile-menu-logo').css('display', 'flex');
    }
    
    // Ocultamos todos los submenús inicialmente
    $('.sub-menu').hide();
    
    // Verificar si el botón hamburguesa existe
    console.log('Botón hamburguesa encontrado:', $('.menu-trigger').length > 0);
    
    // Eliminar eventos previos y agregar nuevo manejador para el botón hamburguesa
    $(".menu-trigger").off('click');
    $(".menu-trigger").on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        console.log('Clic en botón hamburguesa');
        
        // Verificar si el menú está activo
        var isActive = $(this).hasClass('active');
        console.log('Estado actual del menú:', isActive ? 'activo' : 'inactivo');
        
        if (isActive) {
            closeMenu();
        } else {
            openMenu();
        }
    });
    
    // En escritorio: Manejo de hover en elementos con submenús
    $('.has-sub').off('mouseenter').on('mouseenter', function() {
        if (!isMobile) {
            var $parent = $(this);
            var $subMenu = $parent.find('> .sub-menu').first();
            
            // Cerramos todos los submenús primero
            $('.has-sub').removeClass('active');
            $('.sub-menu').hide();
            
            // Mostramos el submenú actual
            $subMenu.show();
            $parent.addClass('active');
            menuState.activeItem = $parent;
        }
    });
    
    // Mantener el enlace principal funcionando
    $('.has-sub > a').off('click').on('click', function(e) {
        // No prevenimos el evento por defecto para permitir la navegación normal
        // Solo prevenimos en móvil
        if (isMobile) {
            e.preventDefault();
        }
    });
    
    // Cerrar submenús al salir del área del menú principal
    $('.header-area .main-nav').off('mouseleave').on('mouseleave', function() {
        if (!isMobile) {
            closeAllSubmenus();
        }
    });
    
    // Cerrar menú móvil al hacer clic en el botón de cierre
    $(".mobile-menu-close").off('click').on('click', function() {
        console.log('Clic en botón de cierre');
        closeMenu();
    });
    
    // Cerrar menú móvil al hacer clic en el overlay (fuera del menú)
    $(".mobile-menu-overlay").off('click').on('click', function() {
        console.log('Clic en overlay');
        closeMenu();
    });
    
    // Manejar submenús en dispositivos móviles
    $('.has-sub > a').off('click').on('click', function(e) {
        if (isMobile) {
            e.preventDefault();
            var $parent = $(this).parent('.has-sub');
            console.log('Clic en elemento con submenú:', $parent.find('> a').text());
            
            // Alternar la clase 'open' para el icono de flecha
            $parent.toggleClass('open');
            
            // Cerrar otros submenús abiertos
            $('.has-sub').not($parent).removeClass('open');
            $('.has-sub').not($parent).find('.sub-menu').slideUp(200);
            
            // Alternar el submenú actual
            $parent.find('.sub-menu').slideToggle(200);
        }
    });
    
    // Activar el enlace correcto en el navbar según la página actual
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    console.log('Página actual:', currentPage);
    const navLinks = document.querySelectorAll('.nav a');
    
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === currentPage || 
            (currentPage === 'index.html' && href === '#top') ||
            (currentPage !== 'index.html' && href && href.includes(currentPage))) {
            link.classList.add('active');
        } else if (link.classList.contains('active')) {
            link.classList.remove('active');
        }
    });
    
    // Corregir enlaces de scroll-to-section en páginas que no son index
    if (currentPage !== 'index.html') {
        const scrollLinks = document.querySelectorAll('.scroll-to-section a');
        scrollLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href && href.startsWith('#') && href !== '#') {
                link.setAttribute('href', 'index.html' + href);
            }
        });
    }
    
    // Asegurarse de que el CSS del menú móvil se aplique correctamente
    if (isMobile) {
        // Forzar la aplicación de estilos CSS para el menú móvil
        $('.header-area .nav').css({
            'display': 'none',
            'position': 'fixed',
            'overflow-y': 'auto',
            'top': '0',
            'right': '-380px',
            'width': '380px',
            'height': '100vh',
            'background-color': '#fff',
            'z-index': '30',
            'box-shadow': '0px 0px 15px rgba(0, 0, 0, 0.1)',
            'transition': 'all .3s ease'
        });
        
        // Asegurar que cuando el menú está activo, se muestre correctamente
        $('.header-area .nav.active').css({
            'display': 'block',
            'right': '0'
        });
        
        // Asegurar que el overlay funcione correctamente
        $('.mobile-menu-overlay').css({
            'position': 'fixed',
            'top': '0',
            'left': '0',
            'width': '100%',
            'height': '100%',
            'background-color': 'rgba(0, 0, 0, 0.7)',
            'z-index': '25',
            'display': 'none',
            'opacity': '0',
            'transition': 'all .3s ease'
        });
        
        $('.mobile-menu-overlay.active').css({
            'display': 'block',
            'opacity': '1'
        });
    }
}

// La función reinitializeFooterFunctions ya está definida arriba
});
