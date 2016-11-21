module Kadmin
  class FinderDecorator < SimpleDelegator
    # @return [Boolean] true if no results, false otherwise
    def empty?
      return self.results.count.zero?
    end

    # @return [String] how many resources are being displayed (along with indices)
    def currently_showing
      resource = resource_name.downcase
      displayed = empty? ? 0 : displayed_items

      currently_showing_phrase = "#{displayed} #{resource}"
      currently_showing_phrase = "#{currently_showing_phrase} (#{offset_start} - #{offset_end})" if self.results.count > 1

      return currently_showing_phrase
    end

    # @return [String] human readable, singular/plural form of the finder's model
    def resource_name
      return self.scope.model_name.human(count: displayed_items)
    end

    # @return [String] a description of the current applied filters
    def applied_filters
      applied_filters = ''
      filters = self.filters.reduce([]) do |acc, (name, filter)|
        next(acc) if filter.value.blank?
        acc << %(<strong>#{filter.value}</strong> on <em>#{name}</em>)
      end
      applied_filters = "(filtering: #{filters.join('; ')})" unless filters.empty?

      return applied_filters.html_safe
    end

    # @!group Pager properties

    # @return [Integer] the current number of items displayed for this page
    def displayed_items
      return offset_end - self.pager.offset
    end

    # @return [Integer] the index number of the last item for this page
    def offset_end
      next_page_offset = self.pager.offset_at(self.pager.current_page + 1)
      return [next_page_offset, self.pager.total].min
    end

    # @return [Integer] the index number of the start item for this page
    def offset_start
      return self.pager.offset + 1
    end

    # @!endgroup
  end
end
