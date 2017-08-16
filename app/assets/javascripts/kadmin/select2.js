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

    return transform(options, this.data("kadmin--transform-request"));
  }

  function transformResponse(data, params) {
    var items = data.data || data.items;
    var options = this.options.options.kadmin || {}; // weird but it is what it is
    var displayProperty = options.displayProperty || "text";
    var valueProperty = options.valueProperty || "id";
    var results = [];
    var response = {};

    jQuery(items).each(function(index, item) {
      results.push({ text: item[displayProperty], id: item[valueProperty] });
    });

    response = {
      results: results,
      pagination: { more: data.more }
    };

    return transform(response, this.$element.data("kadmin--transform-response"));
  }

  function optionsForSelect2(element) {
    return {
      minimumInputLength: jQuery(element).data("kadmin--minimum-input-length") || 2,
    };
  }

  // Data callbacks
  var gFunctions = {};
  function transform(initial, name) {
    var transformed = initial;

    if (name) {
      var callback = lookup(name);
      if (jQuery.isFunction(callback)) {
        transformed = callback(initial);
      }
    }

    return transformed;
  }

  function lookup(path) {
    if (gFunctions[path]) return gFunctions[path];

    var namespaces = path.split(".");
    var functionName = namespaces.pop();
    var context = window;
    var func = null;

    for (var i = 0; context && i < namespaces.length; i++) {
      context = context[namespaces[i]];
    }

    if (jQuery.isFunction(context[functionName])) {
      func = context[functionName];
      gFunctions[path] = func;
    }

    return func;
  }

  // Need to delay a bit otherwise we have issues
  // TODO: Figure out why this happens?
  setTimeout(function() {
    jQuery("select.kadmin-select2").each(function() {
      jQuery(this).select2(optionsForSelect2(this));
    });
  }, 300);

});
