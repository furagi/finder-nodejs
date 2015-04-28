jQuery(document).ready(function ($) {
  'use strict';




  var gallery = $(".ggallery").lightGallery();
    gallery.isActive(); 
    
  $( ".edit" ).click(function() {
    
    $( ".add-categories ul li p" ).attr("contenteditable", "true");
    $( ".add-categories ul li p" ).toggleClass("edit-now");
  }); 
  


  $('.slider').slick({
    slidesToShow: 1,
    slidesToScroll: 1,
    arrows: false,
    autoplay: true,
    fade: true,
    autoplaySpeed: 2000,
  });
  
  
  


});