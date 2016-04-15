// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ckeditor/init
//= require_tree .
var CKEDITOR_BASEPATH = '/ckeditor/';

// $(document).ready(function() {
//   $(".clipped").click(function(){
//     $(this).toggleClass("active");
//   });
// });


$(document).ready(function() {
    $("#switch_scan").click(function() {
        $el1 = $("img.active_scan");
        $el2 = $("img.inactive_scan");
        $el1.removeClass("active_scan").addClass("inactive_scan");
        $el2.removeClass("inactive_scan").addClass("active_scan");
  });
});
