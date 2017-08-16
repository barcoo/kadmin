//= require select2
/* global jQuery */
jQuery(document).ready(function() {
  jQuery.fn.select2.defaults.set("theme", "bootstrap");
  jQuery.fn.select2.defaults.set("ajax", {
    cache: true,
    dataType: "json",
    delay: 300,
    data: transformRequest,
    processResults: transformResponse
  });
  jQuery.fn.select2.defaults.set("allowClear", true);

  function transformRequest(params) {
    var page = params.page || 0;
    var page_size = this.data("kadmin--page-size") || 10;
    var filter_param = this.data("kadmin--filter-param") || null;
    var options = {
      page_offset: page * page_size,
      page_size: page_size
    };

    if (filter_param) {
      options[filter_param] = params.term;
    }

    return options;
  }

  function transformResponse(data, params) {
    var items = data.data || data.items;
    var options = this.options.options.kadmin || {}; // weird but it is what it is
    var displayProperty = options.displayProperty || "text";
    var valueProperty = options.valueProperty || "id";

    var results = [];
    jQuery(items).each(function(index, item) {
      results.push({ text: item[displayProperty], id: item[valueProperty] });
    });

    return {
      results: results,
      pagination: { more: data.more }
    };
  }

  function optionsForSelect2(element) {
    return {
      minimumInputLength: jQuery(element).data("kadmin--minimum-input-length") || 2,
    }
  }

  // Need to delay a bit otherwise we have issues
  // TODO: Figure out why this happens?
  setTimeout(function() {
    jQuery("select.kadmin-select2").each(function() {
      jQuery(this).select2(optionsForSelect2(this));
    });
  }, 300);

});
