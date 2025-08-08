(function ($) {
	
	"use strict";
	// Función para cerrar el código correctamente

	// Configuración del navbar al cargar la página
	$(document).ready(function() {
	  // Calcular la altura exacta del banner morado superior
	  var subHeaderHeight = $('.sub-header').outerHeight();
	  
	  // Configurar el header para que esté exactamente debajo del banner morado
	  $('.header-area').css('top', subHeaderHeight + 'px');
	  
	  // Ajustar el padding-top del main-banner para compensar la altura del navbar
	  var headerHeight = $('.header-area').outerHeight();
	  var totalOffset = subHeaderHeight + headerHeight;
	  
	  // Función de manejo del scroll
	  function handleScroll() {
	    var scroll = $(window).scrollTop();
	    
	    // El navbar se vuelve fijo exactamente cuando el banner morado superior desaparece
	    if (scroll >= subHeaderHeight) {
	      $('header').addClass('background-header');
	    } else {
	      $('header').removeClass('background-header');
	    }
	  }
	  
	  // Ejecutar al inicio para establecer el estado correcto
	  handleScroll();
	  
	  // Asignar el evento de scroll
	  $(window).scroll(handleScroll);
	});
	
	// Menú móvil lateral para dispositivos móviles
	$(document).ready(function() {
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
		
		// Abrir menú móvil al hacer clic en el botón hamburguesa
		$(".menu-trigger").on('click', function(e) {
			e.preventDefault();
			e.stopPropagation();
			console.log('Menu trigger clicked');
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
		
		// Ocultamos todos los submenús inicialmente
		$('.sub-menu').hide();
		
		// En escritorio: Manejo de hover en elementos con submenús
		$('.has-sub').on('mouseenter', function() {
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
		$('.has-sub > a').on('click', function(e) {
			// No prevenimos el evento por defecto para permitir la navegación normal
			// Solo prevenimos en móvil
			if (isMobile) {
				e.preventDefault();
			}
		});
		
		// Cerrar submenús al salir del área del menú principal
		$('.header-area .main-nav').on('mouseleave', function() {
			if (!isMobile) {
				closeAllSubmenus();
			}
		});
		
		// Cerrar submenús al hacer clic fuera del menú
		$(document).on('click', function(e) {
			if (!$(e.target).closest('.has-sub').length && 
				!$(e.target).closest('.sub-menu').length) {
				closeAllSubmenus();
			}
		});
		
		// Prevenir que los clics dentro del submenú cierren el menú
		$('.sub-menu').on('click', function(e) {
			e.stopPropagation();
		});
		
		// Cerrar menú móvil al hacer clic en el botón de cierre
		$(".mobile-menu-close").on('click', function() {
			closeMenu();
		});
		
		// Cerrar menú móvil al hacer clic en el overlay (fuera del menú)
		$(".mobile-menu-overlay").on('click', function() {
			closeMenu();
		});
		
		// Cerrar menú al hacer clic en un enlace del menú
		$('.header-area .main-nav .nav li a, .single-row-menu li a').on('click', function(e) {
			// Si no es un elemento con submenú o si estamos en móvil
			if (!$(this).parent().hasClass('has-sub') || !isMobile) {
				closeMenu();
			}
		});
		
		// Manejar submenús en dispositivos móviles
		$('.has-sub > a').on('click', function(e) {
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
		
		// Actualizar el estado móvil cuando cambia el tamaño de la ventana
		$(window).resize(function() {
			isMobile = window.matchMedia("(max-width: 991px)").matches;
			
			// Restablecer menú en cambio de tamaño
			if (!isMobile) {
				$('.header-area .nav, .single-row-menu').removeClass('active');
				$('.menu-trigger').removeClass('active');
				$('.mobile-menu-overlay').removeClass('active');
				$('body').removeClass('menu-open');
				$('.has-sub').removeClass('open');
				$('.sub-menu').removeAttr('style');
				$('.mobile-menu-logo').css('display', 'none');
			}
		});
	});
	
	$('.filters ul li').click(function(){
        $('.filters ul li').removeClass('active');
        $(this).addClass('active');
          
        var data = $(this).attr('data-filter');
        $grid.isotope({
          filter: data
        });
    });

    var $grid = $(".grid").isotope({
      itemSelector: ".all",
      percentPosition: true,
      masonry: {
        columnWidth: ".all"
      }
    });


	const Accordion = {
	  settings: {
	    // Expand the first item by default
	    first_expanded: false,
	    // Allow items to be toggled independently
	    toggle: false
	  },

	  openAccordion: function(toggle, content) {
	    if (content.children.length) {
	      toggle.classList.add("is-open");
	      let final_height = Math.floor(content.children[0].offsetHeight);
	      content.style.height = final_height + "px";
	    }
	  },

	  closeAccordion: function(toggle, content) {
	    toggle.classList.remove("is-open");
	    content.style.height = 0;
	  },

	  init: function(el) {
	    const _this = this;

	    // Override default settings with classes
	    let is_first_expanded = _this.settings.first_expanded;
	    if (el.classList.contains("is-first-expanded")) is_first_expanded = true;
	    let is_toggle = _this.settings.toggle;
	    if (el.classList.contains("is-toggle")) is_toggle = true;

	    // Loop through the accordion's sections and set up the click behavior
	    const sections = el.getElementsByClassName("accordion");
	    const all_toggles = el.getElementsByClassName("accordion-head");
	    const all_contents = el.getElementsByClassName("accordion-body");
	    for (let i = 0; i < sections.length; i++) {
	      const section = sections[i];
	      const toggle = all_toggles[i];
	      const content = all_contents[i];

	      // Click behavior
	      toggle.addEventListener("click", function(e) {
	        if (!is_toggle) {
	          // Hide all content areas first
	          for (let a = 0; a < all_contents.length; a++) {
	            _this.closeAccordion(all_toggles[a], all_contents[a]);
	          }

	          // Expand the clicked item
	          _this.openAccordion(toggle, content);
	        } else {
	          // Toggle the clicked item
	          if (toggle.classList.contains("is-open")) {
	            _this.closeAccordion(toggle, content);
	          } else {
	            _this.openAccordion(toggle, content);
	          }
	        }
	      });

	      // Expand the first item
	      if (i === 0 && is_first_expanded) {
	        _this.openAccordion(toggle, content);
	      }
	    }
	  }
	};

	(function() {
	  // Initiate all instances on the page
	  const accordions = document.getElementsByClassName("accordions");
	  for (let i = 0; i < accordions.length; i++) {
	    Accordion.init(accordions[i]);
	  }
	})();


	$('.owl-service-item').owlCarousel({
		loop: true,
		dots: true,
		nav: true,
		autoplay: true,
		autoplayTimeout: 6000,
		autoplayHoverPause: true,
		margin: 30,
		center: false,
		items: 3,
		touchDrag: true,
		mouseDrag: true,
		pullDrag: true,
		freeDrag: true, // Permitir arrastre libre para mejor efecto de inercia
		smartSpeed: 450, // Velocidad moderada para transiciones
		navSpeed: 400,
		fluidSpeed: true, // Habilitar velocidad fluida
		dragEndSpeed: true, // Mantener la velocidad al final del arrastre
		responsive: {
			0: {
				items: 1,
				margin: 10,
				center: true,
				dots: true,
				nav: false,
				autoplayTimeout: 4000,
				touchDrag: true,
				mouseDrag: true,
				freeDrag: true,
				fluidSpeed: true,
				dragEndSpeed: true,
				smartSpeed: 350
			},
			480: {
				items: 1,
				margin: 15,
				center: true,
				nav: false,
				autoplayTimeout: 4000,
				stageClass: '',
				stageOuterClass: ''
			},
			576: {
				items: 2,
				margin: 15,
				center: false,
				nav: false
			},
			768: {
				items: 3,
				margin: 20,
				center: false
			},
			992: {
				items: 3,
				margin: 20,
				center: false
			}
		}
	});

	$('.owl-courses-item').owlCarousel({
		items:4,
		loop:true,
		dots: true,
		nav: true,
		autoplay: true,
		margin:30,
		responsive:{
			0:{
				items:1
			},
			600:{
				items:2
			},
			1000:{
				items:4
			}
		}
	});
	
	// Función unificada de scroll suave se implementa más abajo

	$(document).ready(function () {
	    $(document).on("scroll", onScroll);
	    
	    // Smooth scroll mejorado
	    $('.scroll-to-section a[href^="#"]').on('click', function (e) {
	        e.preventDefault();
	        $(document).off("scroll");
	        
	        $('.scroll-to-section a').each(function () {
	            $(this).removeClass('active');
	        });
	        $(this).addClass('active');
	      
	        var target = this.hash;
	        var $target = $(this.hash);
	        
	        if ($target.length) {
	            $('html, body').stop().animate({
	                scrollTop: ($target.offset().top) - 79
	            }, 500, 'swing', function () {
	                window.location.hash = target;
	                $(document).on("scroll", onScroll);
	            });
	        }
	    });
	});

	function onScroll(event){
	    var scrollPos = $(document).scrollTop();
	    $('.nav a[href^="#"]').each(function () {
	        var currLink = $(this);
	        var href = currLink.attr("href");
	        
	        // Verificar que href existe y es un selector válido
	        if (href && href !== '#') {
	            var refElement = $(href);
	            if (refElement.length > 0) {
	                if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
	                    $('.nav ul li a').removeClass("active");
	                    currLink.addClass("active");
	                } else {
	                    currLink.removeClass("active");
	                }
	            }
	        }
	    });
	}


	// Page loading animation
	$(window).on('load', function() {
		if($('.cover').length){
			$('.cover').parallax({
				imageSrc: $('.cover').data('image'),
				zIndex: '1'
			});
		}

		$("#preloader").animate({
			'opacity': '0'
		}, 600, function(){
			setTimeout(function(){
				$("#preloader").css("visibility", "hidden").fadeOut();
			}, 300);
		});
	});

	

	const dropdownOpener = $('.main-nav ul.nav .has-sub > a');

    // Open/Close Submenus
    if (dropdownOpener.length) {
        dropdownOpener.each(function () {
            var _this = $(this);

            _this.on('tap click', function (e) {
                var thisItemParent = _this.parent('li'),
                    thisItemParentSiblingsWithDrop = thisItemParent.siblings('.has-sub');

                if (thisItemParent.hasClass('has-sub')) {
                    var submenu = thisItemParent.find('> ul.sub-menu');

                    if (submenu.is(':visible')) {
                        submenu.slideUp(450, 'easeInOutQuad');
                        thisItemParent.removeClass('is-open-sub');
                    } else {
                        thisItemParent.addClass('is-open-sub');

                        if (thisItemParentSiblingsWithDrop.length === 0) {
                            thisItemParent.find('.sub-menu').slideUp(400, 'easeInOutQuad', function () {
                                submenu.slideDown(250, 'easeInOutQuad');
                            });
                        } else {
                            thisItemParent.siblings().removeClass('is-open-sub').find('.sub-menu').slideUp(250, 'easeInOutQuad', function () {
                                submenu.slideDown(250, 'easeInOutQuad');
                            });
                        }
                    }
                }

                e.preventDefault();
            });
        });
    }


	function visible(partial) {
        // Verificar si el elemento existe y tiene la propiedad offset
        var $t = partial;
        if (!$t || !$t.length || typeof $t.offset !== 'function' || !$t.offset()) {
            return false;
        }
        
        var $w = jQuery(window),
            viewTop = $w.scrollTop(),
            viewBottom = viewTop + $w.height(),
            _top = $t.offset().top,
            _bottom = _top + $t.height(),
            compareTop = partial === true ? _bottom : _top,
            compareBottom = partial === true ? _top : _bottom;

        return ((compareBottom <= viewBottom) && (compareTop >= viewTop) && $t.is(':visible'));

    }

    $(window).scroll(function() {

        if (visible($('.count-digit'))) {
            if ($('.count-digit').hasClass('counter-loaded')) return;
            $('.count-digit').addClass('counter-loaded');

            $('.count-digit').each(function() {
                var $this = $(this);
                jQuery({
                    Counter: 0
                }).animate({
                    Counter: $this.text()
                }, {
                    duration: 3000,
                    easing: 'swing',
                    step: function() {
                        $this.text(Math.ceil(this.Counter));
                    }
                });
            });
        }
    });


})(window.jQuery);