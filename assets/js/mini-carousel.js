// Inicialización del mini-carrusel de logos
$(document).ready(function() {
  // Inicializar el mini-carrusel de logos
  $(".owl-logos-item").owlCarousel({
    center: true,
    items: 1,
    loop: true,
    margin: 5,
    nav: true,
    dots: false,
    autoplay: true,
    autoplayTimeout: 3000,
    autoplayHoverPause: true,
    navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
    responsive: {
      400: {
        items: 2,
        center: false
      },
      576: {
        items: 3,
        center: false
      }
    }
  });
});
