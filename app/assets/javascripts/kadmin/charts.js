//= require chart
/* global jQuery, Chart */
/* eslint no-console: 0 */

jQuery(document).ready(function() {
  jQuery(".kadmin--chart").each(function() {
    var element = jQuery(this);
    var data = parseData(element.data.bind(element));
    var options = {};
    var type = element.data("kadmin--chart-type");
    var context = this.getContext("2d");

    new Chart(context, { type: type, data: data, options: options });

    function parseData(fetcher) {
      var labels = fetcher("kadmin--chart-labels") || [];
      var points = fetcher("kadmin--chart-data") || [];
      var colors = randomColors(points.length);

      return {
        labels: labels,
        datasets: [{ data: points, backgroundColor: colors }]
      };
    }

    function randomColors(amount) {
      var colors = [];
      var pool = ["#3366CC","#DC3912","#FF9900","#109618","#990099","#3B3EAC","#0099C6",
      "#DD4477","#66AA00","#B82E2E","#316395","#994499","#22AA99","#AAAA11","#6633CC",
      "#E67300","#8B0707","#329262","#5574A6","#3B3EAC"];

      for (var i = 0; i < amount; i++) {
        var index = Math.floor(Math.random() * pool.length);
        colors.push(pool[index]);
        pool = pool.slice(0, index).concat(pool.slice(index + 1));
      }

      return colors;
    }
  });
});
