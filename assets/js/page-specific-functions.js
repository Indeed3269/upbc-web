// Script para reinicializar funciones específicas de cada página
document.addEventListener('DOMContentLoaded', function() {
    // Inicializar funciones comunes para todas las páginas
    initializeCommonFunctions();
    
    // Esperar a que los componentes se carguen completamente
    document.addEventListener('componentLoaded', function(e) {
        // Si el componente cargado es el navbar, inicializar sus funciones
        if (e.detail.id === 'navbar-container') {
            initializeNavbarFunctions();
        }
        
        // Reinicializar funciones específicas según la página actual
        const currentPath = window.location.pathname;
        
        // Detectar si estamos en una página de noticias
        if (currentPath.includes('news-') || currentPath.includes('/news/')) {
            console.log('Reinicializando funciones específicas para página de noticias');
            initializeNewsFunctions();
        }
        
        // Detectar si estamos en la página de inicio
        if (currentPath.endsWith('index.html') || currentPath.endsWith('/')) {
            console.log('Reinicializando funciones específicas para página de inicio');
            initializeHomeFunctions();
        }
        
        // Detectar si estamos en la página de calendario
        if (currentPath.includes('calendario')) {
            console.log('Reinicializando funciones específicas para página de calendario');
            initializeCalendarFunctions();
        }
    });
});

// Funciones comunes para todas las páginas
function initializeCommonFunctions() {
    // Configurar el comportamiento del cinturillo morado (sub-header) al hacer scroll
    $(document).ready(function() {
        // Calcular la altura exacta del banner morado superior
        var subHeaderHeight = $('.sub-header').outerHeight();
        
        // Configurar el header para que esté exactamente debajo del banner morado
        $('.header-area').css('top', subHeaderHeight + 'px');
        
        // Función de manejo del scroll para ocultar/mostrar el cinturillo morado
        function handleScroll() {
            var scroll = $(window).scrollTop();
            
            // El navbar se vuelve fijo exactamente cuando el banner morado superior desaparece
            if (scroll >= subHeaderHeight) {
                $('header').addClass('background-header');
                $('.sub-header').addClass('hidden-sub-header');
            } else {
                $('header').removeClass('background-header');
                $('.sub-header').removeClass('hidden-sub-header');
            }
        }
        
        // Ejecutar al inicio para establecer el estado correcto
        handleScroll();
        
        // Asignar el evento de scroll
        $(window).scroll(handleScroll);
    });
}

// Función para inicializar el navbar después de cargarlo
function initializeNavbarFunctions() {
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
}

// Funciones específicas para páginas de noticias
function initializeNewsFunctions() {
    // Asegurarse de que las funciones de compartir estén disponibles globalmente
    if (typeof shareOnFacebook !== 'function') {
        window.shareOnFacebook = function() {
            const url = encodeURIComponent(window.location.href);
            const titleElement = document.getElementById('news-title');
            const title = titleElement ? encodeURIComponent(titleElement.innerText) : encodeURIComponent(document.title);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&t=${title}`, '_blank');
        };
    }
    
    if (typeof shareOnTwitter !== 'function') {
        window.shareOnTwitter = function() {
            const url = encodeURIComponent(window.location.href);
            const titleElement = document.getElementById('news-title');
            const title = titleElement ? encodeURIComponent(titleElement.innerText) : encodeURIComponent(document.title);
            window.open(`https://twitter.com/intent/tweet?url=${url}&text=${title}`, '_blank');
        };
    }
    
    if (typeof shareOnWhatsApp !== 'function') {
        window.shareOnWhatsApp = function() {
            const url = encodeURIComponent(window.location.href);
            const titleElement = document.getElementById('news-title');
            const title = titleElement ? encodeURIComponent(titleElement.innerText) : encodeURIComponent(document.title);
            window.open(`https://api.whatsapp.com/send?text=${title}%20${url}`, '_blank');
        };
    }
    
    if (typeof shareByEmail !== 'function') {
        window.shareByEmail = function() {
            const url = window.location.href;
            const titleElement = document.getElementById('news-title');
            const title = titleElement ? titleElement.innerText : document.title;
            window.location.href = `mailto:?subject=${encodeURIComponent(title)}&body=${encodeURIComponent(`Te comparto esta noticia de la UPBC: ${title}\n\n${url}`)}`;
        };
    }
    
    // Reinicializar los botones de compartir
    const shareButtons = document.querySelectorAll('.news-share a');
    shareButtons.forEach(button => {
        // Limpiar eventos anteriores
        const newButton = button.cloneNode(true);
        button.parentNode.replaceChild(newButton, button);
    });
}

// Funciones específicas para la página de inicio
function initializeHomeFunctions() {
    console.log('Inicializando funciones específicas de la página de inicio');
    
    // Esperar un momento para asegurarnos de que todos los elementos estén cargados
    setTimeout(function() {
        // Reinicializar carruseles si existen
        if (typeof $.fn.owlCarousel === 'function') {
            console.log('OwlCarousel está disponible, inicializando carruseles...');
            
            // Destruir instancias previas de carruseles si existen
            if ($('.owl-main-carousel').hasClass('owl-loaded')) {
                $('.owl-main-carousel').trigger('destroy.owl.carousel');
            }
            
            if ($('.owl-service-item').hasClass('owl-loaded')) {
                $('.owl-service-item').trigger('destroy.owl.carousel');
            }
            
            // Reinicializar carrusel principal si existe
            if ($('.owl-main-carousel').length > 0) {
                console.log('Inicializando carrusel principal, elementos encontrados:', $('.owl-main-carousel').length);
                $('.owl-main-carousel').owlCarousel({
                    items: 1,
                    loop: true,
                    dots: true,
                    nav: true,
                    autoplay: true,
                    autoplayTimeout: 5000,
                    autoplayHoverPause: true,
                    animateOut: 'fadeOut',
                    animateIn: 'fadeIn',
                    smartSpeed: 1000,
                    navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
                    margin: 0,
                    responsive: {
                        0: {
                            items: 1
                        },
                        600: {
                            items: 1
                        },
                        1000: {
                            items: 1
                        }
                    }
                });
            } else {
                console.log('No se encontró el carrusel principal (.owl-main-carousel)');
            }
            
            // Reinicializar carrusel de servicios si existe
            if ($('.owl-service-item').length > 0) {
                console.log('Inicializando carrusel de servicios, elementos encontrados:', $('.owl-service-item').length);
                $('.owl-service-item').owlCarousel({
                    loop: true,
                    margin: 30,
                    nav: true,
                    dots: true,
                    autoplay: true,
                    autoplayTimeout: 5000,
                    smartSpeed: 1000,
                    responsive: {
                        0: {
                            items: 1
                        },
                        600: {
                            items: 2
                        },
                        1000: {
                            items: 3
                        }
                    }
                });
            } else {
                console.log('No se encontró el carrusel de servicios (.services-carousel)');
            }
        } else {
            console.error('OwlCarousel no está disponible');
        }
        
        // Reinicializar acordeones si existen
        if ($('.accordions').length > 0) {
            console.log('Inicializando acordeones');
            $('.accordion-head').off('click').on('click', function() {
                $(this).toggleClass('active');
                $(this).parent().find('.accordion-body').slideToggle(300);
            });
            
            // Asegurarse de que el primer acordeón esté expandido
            if ($('.accordions.is-first-expanded').length > 0) {
                $('.accordions.is-first-expanded .accordion:first-child .accordion-head').addClass('active');
                $('.accordions.is-first-expanded .accordion:first-child .accordion-body').show();
            }
        }
    }, 500); // Esperar 500ms para asegurar que todo esté cargado
}

// Funciones específicas para la página de calendario
function initializeCalendarFunctions() {
    // Reinicializar visor de PDF si existe
    if (typeof pdfjsLib !== 'undefined') {
        // Código para inicializar el visor de PDF
        console.log('Reinicializando visor de PDF');
    }
}
