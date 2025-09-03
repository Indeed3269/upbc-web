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

	// NOTA: La funcionalidad del menú móvil se ha movido a components-loader.js
	// para evitar conflictos de inicialización múltiple
	
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