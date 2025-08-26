// Función para cargar componentes HTML desde subcarpeta
document.addEventListener('DOMContentLoaded', function() {
    // Cargar el navbar
    loadComponent('../../components/navbar.html', 'navbar-container')
        .then(() => {
            // Reinicializar funcionalidades del navbar después de cargarlo
            reinitializeNavbarFunctions();
        });
    
    // Cargar el footer
    loadComponent('../../components/footer.html', 'footer-container')
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
        // Corregir rutas en imágenes
        element.querySelectorAll('img').forEach(img => {
            const src = img.getAttribute('src');
            if (src && src.startsWith('assets/')) {
                img.setAttribute('src', '../../' + src);
            }
        });
        
        // Corregir rutas en enlaces
        element.querySelectorAll('a').forEach(a => {
            const href = a.getAttribute('href');
            if (href && !href.startsWith('http') && !href.startsWith('#') && !href.startsWith('javascript')) {
                if (href === 'index.html' || href.startsWith('index.html')) {
                    a.setAttribute('href', '../../' + href);
                } else if (href.startsWith('assets/')) {
                    a.setAttribute('href', '../../' + href);
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
    
    // Reinicializar el menú móvil
    $('.menu-trigger').on('click', function() {
        $('.mobile-menu-overlay').toggleClass('active');
        $('.menu-container').toggleClass('active');
        $('.mobile-menu-logo').show();
    });
    
    $('.mobile-menu-close').on('click', function() {
        $('.mobile-menu-overlay').removeClass('active');
        $('.menu-container').removeClass('active');
    });
}

// Función para reinicializar las funcionalidades del footer
function reinitializeFooterFunctions() {
    // Cualquier funcionalidad específica del footer que necesite reinicializarse
}
