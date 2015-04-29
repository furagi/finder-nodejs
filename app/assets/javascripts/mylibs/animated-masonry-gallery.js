$(window).load(function () {




  var size = 1;
  var button = 1;
  var button_class = "gallery-header-center-right-links-current";
  var normal_size_class = "gallery-content-center-normal";
  var full_size_class = "gallery-content-center-full";
  var $container = $('#gallery-content-center');

  $container.isotope({
    itemSelector: 'li.girl'
  });


  function check_button() {
    $('.gallery-links').removeClass(button_class);
    if (button == 1) {
      $("#filter-all").addClass(button_class);
      $("#gallery-header-center-left-title").html('All Galleries');
    }
    if (button == 2) {
      $("#filter-studio").addClass(button_class);
      $("#gallery-header-center-left-title").html('Studio Gallery');
    }
    if (button == 3) {
      $("#filter-landscape").addClass(button_class);
      $("#gallery-header-center-left-title").html('Landscape Gallery');
    }
  }



  $("#gallery-header .gallery-links").click(function() {
    var category_id = $(this).data('filter');
    var filter = '.category-' + category_id;
    $container.isotope({
      filter: filter
    });
  });

  $("#filter-all").click(function () {
    $container.isotope({
      filter: '.all'
    });
    button = 1;
    check_button();
  });
  $("#gallery-header-center-left-icon").click(function () {
    if (size == 0) {
      size = 1;
    } else if (size == 1) {
      size = 0;
    }
    check_size();
  });


  check_button();
  check_size();
});
