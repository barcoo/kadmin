module Kadmin
  module Pagination
    # Simple Pager structure, used to paginate collections
    class Pager
      # @return [Integer] number of items per page
      attr_reader :size

      # @return [Integer] current index offset (determines current page)
      attr_reader :offset

      # @return [Integer] total number of pages
      attr_reader :pages

      # @return [Integer] the current page
      attr_reader :current_page

      # @return [Integer] total number of items in the collection
      attr_reader :total

      # @param [Integer] size size of a page
      # @param [Integer] offset offset/index for the current page
      def initialize(size:, offset:)
        @size = size
        @offset = offset

        raise(Kadmin::Error, 'Page size must be greater than 0!') unless @size.positive?
        raise(Kadmin::Error, 'Offset must be at least 0!') unless @offset >= 0

        @current_page = (@offset / @size.to_f).floor
        self.total = @size # assume page size is maximum initially
      end

      # @param [ActiveRecord::Relation] collection relation to paginate
      # @return [ActiveRecord::Relation] paginated collection
      def page(collection)
        self.total = collection.count

        collection = collection.offset(@offset)
        collection = collection.limit(@size)

        return collection
      end

      # @param [Integer] page the page to get the offset for; if not given, uses the current page
      # @return [Integer] start offset for the given page
      def offset_at(page = nil)
        page ||= @current_page
        return @size * page.to_i
      end

      # @param [Integer] page the page to check for
      # @return [Boolean] true if `page` is the current page
      def current_page?(page)
        return page == @current_page
      end

      # @param [Integer] page the page to check for
      # @return [Boolean] true if `page` exists (i.e. would have any data)
      def contains?(page)
        page.in?(0...@pages)
      end

      # @param [Integer] total sets the number of total collection items (not total loaded)
      def total=(total)
        @total = total
        @pages = (@total / @size.to_f).ceil
      end

      # @param [Integer] page optional; if not given, uses the current page
      # @return [Integer] the number of items that are on this page
      def page_size(page = nil)
        page ||= @current_page
        page_start = offset_at(page)
        page_end = [offset_at(page.to_i + 1), @total].min

        return page_end - page_start
      end

      # @param [Integer] page optional; if given, checks if the page after would have any data, otherwise checks based on the current page
      # @return [Boolean] true if there is a next page
      def next_page?(page = nil)
        page ||= @current_page
        return offset_at(page.to_i + 1) < @total
      end

      # @param [Integer] page optional; if given, checks if the page after would have any data, otherwise checks based on the current page
      # @return [Boolean] true if there is a previous page
      def previous_page?(page = nil)
        page ||= @current_page

        return page.to_i.positive?
      end
    end
  end
end
