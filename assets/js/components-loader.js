// Función para cargar componentes HTML
document.addEventListener('DOMContentLoaded', function() {
    // Cargar el navbar
    loadComponent('components/navbar.html', 'navbar-container')
        .then(() => {
            // Reinicializar funcionalidades del navbar después de cargarlo
            reinitializeNavbarFunctions();
        });
    
    // Cargar el footer
    loadComponent('components/footer.html', 'footer-container')
        .then(() => {
            // Reinicializar funcionalidades del footer después de cargarlo
            reinitializeFooterFunctions();
        });
    
    // Función para cargar componentes HTML
    function loadComponent(url, targetId) {
        const target = document.getElementById(targetId);
        if (!target) return Promise.resolve();
        
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
                fixRelativePaths(target, url);
                
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
    
    // Función para corregir rutas relativas en los componentes cargados
    function fixRelativePaths(element, componentUrl) {
        // Determinar el nivel de profundidad de la página actual
        const currentPath = window.location.pathname;
        const pathSegments = currentPath.split('/').filter(segment => segment.length > 0);
        const depth = pathSegments.length - 1; // -1 porque el último segmento es el archivo HTML
        
        // Prefijo para rutas relativas
        let prefix = '';
        if (depth > 0) {
            prefix = '../'.repeat(depth);
        }
        
        // Corregir rutas en imágenes
        element.querySelectorAll('img').forEach(img => {
            const src = img.getAttribute('src');
            if (src && src.startsWith('assets/')) {
                img.setAttribute('src', prefix + src);
            }
        });
        
        // Corregir rutas en enlaces
        element.querySelectorAll('a').forEach(a => {
            const href = a.getAttribute('href');
            if (href && !href.startsWith('http') && !href.startsWith('#') && !href.startsWith('javascript')) {
                if (href.startsWith('index.html') || href === 'index.html') {
                    a.setAttribute('href', prefix + href);
                } else if (href.startsWith('assets/')) {
                    a.setAttribute('href', prefix + href);
                }
            }
        });
    }
});

// Función para reinicializar las funcionalidades del navbar
function reinitializeNavbarFunctions() {
    // Calcular la altura exacta del banner morado superior
    var subHeaderHeight = $('.sub-header').outerHeight();
    
    // Configurar el header para que esté exactamente debajo del banner morado
    $('.header-area').css('top', subHeaderHeight + 'px');
    
    // Detectar si estamos en vista móvil
    var isMobile = window.matchMedia("(max-width: 991px)").matches;
    
    // Variable para rastrear el estado del menú
    var menuState = {
        activeItem: null
    };
    
    // Función para cerrar todos los submenús
    function closeAllSubmenus() {
        $('.has-sub').removeClass('active');
        $('.sub-menu').hide();
        menuState.activeItem = null;
    }
    
    // Función para cerrar el menú móvil
    function closeMenu() {
        $('.menu-trigger').removeClass('active');
        $('.header-area .nav, .single-row-menu').removeClass('active');
        $('.mobile-menu-overlay').removeClass('active');
        $('body').removeClass('menu-open');
        // Ocultar el logo móvil cuando se cierra el menú
        $('.mobile-menu-logo').css('display', 'none');
    }
    
    // Ocultamos todos los submenús inicialmente
    $('.sub-menu').hide();
    
    // Abrir menú móvil al hacer clic en el botón hamburguesa
    $(".menu-trigger").off('click').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).toggleClass('active');
        $('.header-area .main-nav .nav').toggleClass('active');
        $('.single-row-menu').toggleClass('active');
        $('.mobile-menu-overlay').toggleClass('active');
        $('body').toggleClass('menu-open');
        // Mostrar el logo móvil cuando se abre el menú
        if ($(this).hasClass('active')) {
            $('.mobile-menu-logo').css('display', 'flex');
        } else {
            $('.mobile-menu-logo').css('display', 'none');
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
        closeMenu();
    });
    
    // Cerrar menú móvil al hacer clic en el overlay (fuera del menú)
    $(".mobile-menu-overlay").off('click').on('click', function() {
        closeMenu();
    });
    
    // Manejar submenús en dispositivos móviles
    $('.has-sub > a').off('click').on('click', function(e) {
        if (isMobile) {
            e.preventDefault();
            var $parent = $(this).parent('.has-sub');
            
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
}

// Función para reinicializar las funcionalidades del footer
function reinitializeFooterFunctions() {
    // Reinicializar cualquier funcionalidad específica del footer aquí
    // Por ejemplo, validación de formularios, suscripción al boletín, etc.
    
    // Ejemplo: Formulario de boletín informativo
    $('.footer-newsletter').off('submit').on('submit', function(e) {
        e.preventDefault();
        // Lógica para manejar la suscripción al boletín
        const email = $(this).find('input[type="email"]').val();
        if (email) {
            console.log('Suscripción al boletín:', email);
            // Aquí iría el código para enviar la suscripción
            $(this).find('input[type="email"]').val('');
            alert('¡Gracias por suscribirte a nuestro boletín!');
        }
    });
}

// Función para activar el enlace correcto en el navbar según la página actual
document.addEventListener('componentLoaded', function(e) {
    if (e.detail.id === 'navbar-container') {
        const currentPage = window.location.pathname.split('/').pop() || 'index.html';
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
    }
});
