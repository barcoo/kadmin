# frozen_string_literal: true

module Kadmin
  # Provide helpers for displaying charts based on http://www.chartjs.org/
  # Eventually add more, and just map the labels/data correctly.
  module ChartsHelper
    def charts_doughnut_tag(*args)
      charts_tag('doughnut', *args)
    end

    def charts_pie_tag(*args)
      charts_tag('pie', *args)
    end

    def charts_tag(type, data = [], labels = [], html_options = {})
      html_options = {
        class: 'kadmin--chart',
        data: {
          'kadmin--chart-type': type,
          'kadmin--chart-labels': labels.to_json.tr('"', '\"'),
          'kadmin--chart-data': data.to_json.tr('"', '\"')
        }
      }.merge(html_options)

      return content_tag(:canvas, '', html_options)
    end
  end
end
