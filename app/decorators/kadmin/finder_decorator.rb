module Kadmin
  class FinderDecorator
    # @return [Kadmin::Finder] underlying finder model
    attr_reader :finder

    delegate :filters, :scope, :results, to: :finder

    def initialize(finder)
      @finder = finder
    end

    # @return [Boolean] true if no results, false otherwise
    def empty?
      return finder.results.count.zero?
    end

    # @return [String] how many resources are being displayed (along with indices)
    def currently_showing
      resource = resource_name.downcase
      displayed = empty? ? 0 : pager.displayed_items

      currently_showing_phrase = "#{displayed} #{resource}"
      currently_showing_phrase = "#{currently_showing_phrase} (#{pager.page_start} - #{pager.page_end})" if finder.results.count > 1

      return currently_showing_phrase
    end

    # @return [String] human readable, singular/plural form of the finder's model
    def resource_name
      return @finder.scope.model_name.human(count: pager.displayed_items)
    end

    # @return [String] a description of the current applied filters
    def applied_filters
      applied_filters = ''
      filters = @finder.filters.reduce([]) do |acc, (name, filter)|
        next(acc) if filter.value.blank?
        acc << %(<strong>#{filter.value}</strong> on <em>#{name}</em>)
      end
      applied_filters = "(filtering: #{filters.join('; ')})" unless filters.empty?

      return applied_filters.html_safe
    end

    # @return [Kadmin::Pagination::Presenter] decorated pager of the underlying finder
    def pager
      return @pager ||= Kadmin::Pagination::Presenter.new(@finder.pager)
    end
  end
end
