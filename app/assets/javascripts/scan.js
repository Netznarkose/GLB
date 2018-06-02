$(document).ready(function () {
  set_page_number()
});

$(document).on("page:load", function() {
  set_page_number()
})

function fetchPageNumber() {
  return document.getElementById("kennzahl").dataset.kennzahl;
}

function setPageDescription(page_number, page_title = 'oben') {
  return document.getElementById("page_count").innerHTML = ' ' + page_number.toString() + ', ' + page_title;
}
function set_page_number() {
  count = 0;
  let default_page_number = fetchPageNumber();
  setPageDescription(default_page_number)
}

function processTitles(count) { // refactoring
  if (count === 1 || count === 4 || count === 7) {
    return 'mitte'
  } else if (count === 2 || count === 5 || count === 8) {
    return 'unten'
  } else {
    return 'oben'
  }
}
function write_page_count() {
  var page_number_as_integer = Math.floor(fetchPageNumber());
  var add_count_to_page_number = page_number_as_integer + (Math.floor(count / 3));
  setPageDescription(add_count_to_page_number, processTitles(count));
}

function page_first() {
  count = 0;
  write_page_count();
  select_image()
}

function page_down() {
  if(count >= 1) count -= 1;
  write_page_count();
  select_image()
}

function page_up() {
  if(count <= 7) count += 1;
  write_page_count();
  select_image()
}

function select_image() {
  let page_ids = fetch_page_ids()
  page_ids.forEach(function(page, index) {
    document.getElementById(page).style.display = count === index ? 'block' : 'none';
  })
};

function fetch_page_ids() {
  let page_ids = [];
  document.querySelectorAll('img').forEach(function(img) {
    page_ids.push(img.id);
  });
  return page_ids
}
