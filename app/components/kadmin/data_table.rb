# frozen_string_literal: true

module Kadmin
  # Wraps datatable information and delegates most of the functionality to
  # the Finder class.
  class DataTable
    Column = Struct.new(:name, :order, :query, :searchable, :orderable)

    # @return [Integer]
    attr_reader :draw

    def initialize(scope, **options)
      @scope = scope
      parse_options(options)
    end

    def data
      finder.results
    end

    def finder
      @finder ||= create_finder

    def data
      @data ||= finder.results
    end

    # recordsTotal and recordsFiltered are currently the same,
    # since we for some tables calculating the number of records
    # could be quite slow
    def records_total
      finde.pager.total
    end
    alias records_total records_filtered

    private

    def create_finder
      finder = Kadmin::Finder.new(scope)

      @columns.each do |column|
        finder.order(column: column.name, dir: column.order.to_s) if column.orderable
        finder.filter(name: column.name, column: column.name, value: column.query.to_s) if column.searchable
      end

      finder.paginate(start: @start, limit: @length) if @length.positive?
    end

    def parse_options(options)
      options = { columns: [], start: nil, length: -1 }.merge(options)

      @columns = Array.wrap(columns).freeze
      @start = start.to_i
      @length = length.to_i
    end
  end
end
