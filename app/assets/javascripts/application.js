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

var count = 0;
var pages = ["page0", "page1", "page2", "page3", "page4"];

function back_first_switch() {
  count = 0;
  write_page_count();
}

function back_switch() {
  if (count <= 0) {
    count = 0;
  } else {
    count--;
  }
  write_page_count();
}

function forward_switch() {
  if (count >= 4) {
    count = 4;
  } else {
    count++;
  }
  write_page_count();
}

function write_page_count() {
  document.getElementById("page_count").innerHTML = "Seite " + (count + 1);

  for (var i = 0; i < 5; i++) {
    if (count == i) {
      document.getElementById(pages[i]).style.display = "block";
    } else {
      document.getElementById(pages[i]).style.display = "none";
    }
  }

}

