// Script para el carrusel de noticias
document.addEventListener('DOMContentLoaded', function() {
    // Elementos del carrusel
    const carousel = document.getElementById('news-carousel');
    const prevButton = document.getElementById('news-prev');
    const nextButton = document.getElementById('news-next');
    const pageIndicators = document.querySelectorAll('.news-page-indicator');
    
    // Variables de control
    let currentPage = 0;
    let totalPages = 0;
    let itemsPerPage = 4; // Por defecto para desktop
    let newsItems = [];
    let isDesktopView = false;
    
    // Función para inicializar el carrusel
    function initCarousel() {
        // Obtener todos los elementos de noticias
        newsItems = Array.from(carousel.querySelectorAll('.news-item'));
        
        // Determinar el número de elementos por página según el ancho de la pantalla
        updateItemsPerPage();
        
        // Calcular el número total de páginas
        totalPages = Math.ceil(newsItems.length / itemsPerPage);
        
        // Actualizar los indicadores de página
        updatePageIndicators();
        
        // Mostrar la primera página
        showPage(0);
    }
    
    // Función para actualizar el número de elementos por página según el ancho de la pantalla
    function updateItemsPerPage() {
        isDesktopView = window.innerWidth >= 992;
        
        if (isDesktopView) {
            itemsPerPage = 4; // Desktop: 4 noticias por página (2x2)
        } else if (window.innerWidth >= 768) {
            itemsPerPage = 3; // Tablet: 3 noticias por página
        } else {
            itemsPerPage = 2; // Móvil: 2 noticias por página
        }
    }
    
    // Función para mostrar una página específica
    function showPage(pageIndex) {
        if (pageIndex < 0 || pageIndex >= totalPages) return;
        
        // Actualizar la página actual
        currentPage = pageIndex;
        
        if (isDesktopView) {
            // En escritorio, mostrar/ocultar elementos para el formato 2x2
            newsItems.forEach((item, index) => {
                const startIndex = currentPage * itemsPerPage;
                const endIndex = startIndex + itemsPerPage;
                
                if (index >= startIndex && index < endIndex) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        } else {
            // En móvil y tablet, usar transformación horizontal
            const itemWidth = newsItems[0].offsetWidth;
            const translateX = -pageIndex * itemsPerPage * itemWidth;
            carousel.style.transform = `translateX(${translateX}px)`;
        }
        
        // Actualizar los indicadores de página
        updatePageIndicators();
        
        // Habilitar/deshabilitar botones de navegación
        updateNavigationButtons();
    }
    
    // Función para actualizar los indicadores de página
    function updatePageIndicators() {
        // Crear o actualizar los indicadores de página
        const paginationContainer = document.querySelector('.news-pagination');
        paginationContainer.innerHTML = '';
        
        for (let i = 0; i < totalPages; i++) {
            const indicator = document.createElement('span');
            indicator.className = 'news-page-indicator';
            if (i === currentPage) {
                indicator.classList.add('active');
            }
            indicator.dataset.page = i;
            indicator.addEventListener('click', () => showPage(i));
            paginationContainer.appendChild(indicator);
        }
    }
    
    // Función para actualizar los botones de navegación
    function updateNavigationButtons() {
        prevButton.style.opacity = currentPage === 0 ? '0.3' : '0.7';
        nextButton.style.opacity = currentPage === totalPages - 1 ? '0.3' : '0.7';
    }
    
    // Evento para el botón anterior
    prevButton.addEventListener('click', () => {
        showPage(currentPage - 1);
    });
    
    // Evento para el botón siguiente
    nextButton.addEventListener('click', () => {
        showPage(currentPage + 1);
    });
    
    // Evento para redimensionar la ventana
    window.addEventListener('resize', () => {
        // Guardar el estado actual
        const wasDesktopView = isDesktopView;
        const oldItemsPerPage = itemsPerPage;
        
        // Actualizar el número de elementos por página
        updateItemsPerPage();
        
        // Si cambió el modo de visualización o el número de elementos por página
        if (wasDesktopView !== isDesktopView || oldItemsPerPage !== itemsPerPage) {
            // Resetear estilos si cambiamos entre modos
            if (wasDesktopView !== isDesktopView) {
                // Si cambiamos de escritorio a móvil/tablet
                if (!isDesktopView) {
                    newsItems.forEach(item => {
                        item.style.display = 'block';
                    });
                    carousel.style.transform = 'translateX(0)';
                }
            }
            
            // Recalcular páginas y mostrar la primera
            totalPages = Math.ceil(newsItems.length / itemsPerPage);
            currentPage = 0;
            updatePageIndicators();
            showPage(0);
        }
    });
    
    // Inicializar el carrusel
    initCarousel();
});
