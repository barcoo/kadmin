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

        finder = Kadmin::Finder.new(scope)
        finder.paginate(size: page_size, offset: page_offset)
        filters.each do |filter|
          finder.filter(name: filter[:name], column: filter[:column], value: permitted[filter[:param]])
        end

        return finder
      end
    end
  end
end
