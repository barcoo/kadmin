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
      def respond_with_finder(finder, filters = [])
        filter_params = filters.map { |hash| hash[:param] }
        permitted = params.permit(:page_size, :page_offset, :format, *filter_params)

        page_size = params.fetch(:page_size, DEFAULT_FINDER_PAGE_SIZE).to_i
        page_offset = params.fetch(:page_offset, 0).to_i

        finder.paginate(size: page_size, offset: page_offset)
        filters.each do |filter|
          finder.filter(name: filter[:name], column: filter[:column], value: params[filter[:param]])
        end

        @finder = finder.present

        respond_to do |format|
          format.all
          format.js { render json: @finder.ajax_response }
        end
      end
    end
  end
end
