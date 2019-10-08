//= require modular
//= require jquery_ujs
//= require_tree .
//= require jquery.datetimepicker.full

// sortable tables

$( document ).ready(function() {
  //commit=Filter&filter_name=test&page_offset=100&page_size=500&sort_asc=true&sort_column=
  const urlParams = new URLSearchParams(window.location.search);
  var params = {
    commit: urlParams.get('commit'),
  };

  if (urlParams.get('page_size')) {
    params['page_size'] = urlParams.get('page_size');
  }

  // adding filter(s)
  for (let param of urlParams) {
    if (param[0].startsWith('filter_')) {
      params[param[0]] = param[1];
    } 
  }

  var path = window.location.pathname+'?';
  
  $('th[sort-column]').each(function() {
    var currentColumnName = $(this).attr('sort-column');
    params['sort_column'] = currentColumnName;
    
    params['sort_asc'] = 'true';
    var sortIndicator = ""; 
    if (urlParams.get('sort_column') === currentColumnName) {
      //reverse sort order
      if (urlParams.get('sort_asc') === 'true') {
        params['sort_asc'] = 'false';
        sortIndicator = '&nbsp;&#x25B4;';
      }
      else {
        params['sort_asc'] = 'true';
        sortIndicator = '&nbsp;&#x25BE;';
      }
    } 

    var linkElement = $( "<a/>", {
      style: "padding:0;",
      html: $(this).html() + sortIndicator,
      "class": "btn btn-default",
      href: path + $.param(params)
    });
     
    $(this).html(linkElement);
  });
});