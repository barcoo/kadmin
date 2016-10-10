module Kadmin
  class PagerDecorator
    # @return [Kadmin::Pager] underlying pager model
    attr_reader :pager

    delegate :total, :size, :offset, :pages, :current_page, :contains?, :next_page?,
      :previous_page?, :offset_at, :current_page?,
      to: :pager

    def initialize(pager)
      @pager = pager
    end

    # @return [Integer] the current number of items displayed for this page
    def displayed_items
      return page_end - offset
    end

    # @return [Integer] the index number of the last item for this page
    def page_end
      return [next_page_offset, total].min
    end

    # @return [Integer] the index number of the start item for this page
    def page_start
      return offset + 1
    end

    def next_page_offset
      return @pager.offset_at(current_page + 1)
    end
  end
end
