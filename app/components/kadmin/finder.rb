# frozen_string_literal: true

module Kadmin
  class Finder
    include Kadmin::Presentable

    # @return [Kadmin::Pager] the pager to use (if any)
    attr_reader :pager

    # @return [Hash<String, Kadmin::Finder::Filter>] array of filters applied to the finder
    attr_reader :filters

    # @return [ActiveRecord::Relation] the base relation to find items from
    attr_reader :scope

    # @return [String] name of column that is used in ORDER_BY clause
    attr_reader :sort_column

    # @return [bool] true if sort order is ASC, false if DESC
    attr_reader :sort_asc

    # @param [ActiveRecord::Relation] scope base relation to page/filter on
    def initialize(scope)
      @scope = scope
      @pager = nil
      @filters = {}
      @results = nil
      @filtering = false
      @sort_asc = true
    end

    # @param [String] name the filter name (should be unique)
    # @param [String, Array<String>] column the column(s) name to filter on
    # @param [String, Array<String>] value the value or values to look for (OR'd)
    def filter(filter, value = nil)
      @filters[filter.name] = filter
      if value.present?
        @filtering = true
        @scope = filter.apply(@scope, value)
      end

      return self
    end

    # sets sort order for scope, any existing order is overwritten
    # @param [String] name of column to sort
    # @param [bool] true for ASC sort, false otherwise
    def order(sort_column, sort_asc)
      @sort_column = sort_column
      @sort_asc = sort_asc
      @scope = @scope.reorder("#{sort_column} #{sort_asc ? 'ASC' : 'DESC'}")
    end

    def filtering?
      return @filtering
    end

    # @param [Integer] offset optional; offset/index for the current page
    # @param [Integer] size optional; size of a page
    # @return [Kadmin::Finder] itself
    def paginate(offset: nil, size: nil)
      offset = offset.to_i
      size = size.to_i

      if size.positive? && offset >= 0
        @pager = Kadmin::Pager.new(size: size, offset: offset)
      end

      return self
    end

    # @return [ActiveRecord::Relation] the filtered (and optionally paginated) results
    def results
      return @results ||= begin
        results = @scope
        results = @pager.paginate(results) unless @pager.nil?
        results.load
        results
      end
    end

    # Forces to refetch/recalculate the find operation results
    def find!
      @total_found = 0
      @results = nil
      return results
    end
  end
end
