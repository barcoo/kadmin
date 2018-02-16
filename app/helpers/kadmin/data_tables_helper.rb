# frozen_string_literal: true

module Kadmin
  # View helpers for generating DataTables
  class DataTablesHelper
    def datatables_table(url, columns, html_options = {})
      columns_json = columns.map { |c| c.slice(:data) }
      html_options = {
        data: {
          'kadmin--ajax-url' => url,
          'kadmin--columns-json' => columns_json.to_json.tr('"', '\"')
        }
      }.merge(html_options)

      columns_html = columns.map { |c| "<th>#{c[:label]}</th>" }.join('')
      table_header = "<thead><tr>#{columns_html}</tr></thead>".html_safe
      return content_tag(:table, table_header, html_options)
    end
  end
end
