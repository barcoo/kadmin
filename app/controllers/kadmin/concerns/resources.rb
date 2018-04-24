# frozen_string_literal: true

module Kadmin
  module Concerns
    module Resources
      extend ActiveSupport::Concern

      # Default finder page size
      DEFAULT_FINDER_PAGE_SIZE = 100

      # Does not return anything, but will modify your finder instance.
      # @param [Kadmin::Finder] finder the finder to respond with
      # @param [Array<String>] filters an array of filters, of format: { name:, column:, param: }
      def resources_finder(scope, filters = [])
        filters = Array.wrap(filters)
        filter_params = filters.map { |hash| hash[:param] }
        permitted = params.permit(:page_size, :page_offset, :format, *filter_params)

        page_size = permitted.fetch(:page_size, DEFAULT_FINDER_PAGE_SIZE).to_i
        page_offset = permitted.fetch(:page_offset, 0).to_i

        finder = Finder.new(scope)
        finder.paginate(size: page_size, offset: page_offset)
        filters.each do |hash|
          value = permitted[hash[:param]]
          filter = if hash[:filter].present?
            Finder::Filter.new(hash[:name], hash[:filter])
          else
            resources_deprecated_parse_filter(hash)
          end

          finder.filter(filter, value)
        end

        return finder
      end

      private

      # Takes in a column or array of column names, and returns a proc
      # ready to be used by this class.
      # Columns can contain either symbols, strings, or directly an Arel::Node,
      # allowing you to reference joined tables as well.
      def resources_filter_matches(columns)
        return lambda do |v|
          pattern = "%#{v}%"
          conditions = Array.wrap(columns).reduce(nil) do |acc, column|
            column = arel_table[column] unless column.is_a?(Arel::Attributes::Attribute)
            matcher = column.matches(pattern)
            acc.nil? ? matcher : acc.or(matcher)
          end

          where(conditions)
        end
      end

      # DEPRECATED
      def resources_deprecated_parse_filter(hash)
        filter_scope = resources_filter_matches(hash[:column])
        Finder::Filter.new(name: hash[:name], scope: filter_scope)
      end
    end
  end
end
