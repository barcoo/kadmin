module Kadmin
  class FinderDecorator
    # @return [Kadmin::Finder] underlying finder model
    attr_reader :finder

    delegate :filters, :scope, :results, to: :finder

    def initialize(finder)
      @finder = finder
    end

    # @return [String] human readable, singular/plural form of the finder's model
    def resource_name
      return @finder.scope.model_name.human(count: pager.displayed_items)
    end

    # @return [String] a description of the current applied filters
    def applied_filters
      filters = @finder.filters.reduce([]) do |acc, (name, filter)|
        next(acc) if filter.value.blank?
        acc << %(<strong>#{filter.value}</strong> on <em>#{name}</em>).html_safe
      end
      applied_filters = "(filtering: #{filters.join('; ')})" unless filters.empty?

      return applied_filters
    end

    # @return [Kadmin::PagerDecorator] decorated pager of the underlying finder
    def pager
      return @pager ||= Kadmin::PagerDecorator.new(@finder.pager)
    end
  end
end
