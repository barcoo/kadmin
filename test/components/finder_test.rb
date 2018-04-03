# frozen_string_literal: true

require 'test_helper'

module Kadmin
  class FinderTest < ActiveSupport::TestCase
    def setup
      super

      Person.create(first_name: 'John', last_name: 'Doe', gender: 'm', date_of_birth: 25.years.ago)
      Person.create(first_name: 'Jane', last_name: 'Johnson', gender: 'f', date_of_birth: 25.years.ago)
      @finder = Kadmin::Finder.new(Person.all)
    end

    def test_filter
      assert !@finder.filtering?

      filter = Finder::Filter.new(name: 'gender', scope: ->(v) { where(gender: v) })
      @finder.filter(filter, '')
      assert !@finder.filtering?, 'Should still not be filtering since a blank value was passed'
      assert_equal @finder.scope, Person.all, 'Scope should not have changed yet'

      filter = Finder::Filter.new(name: 'name', scope: ->(v) { where("first_name LIKE '%#{v}%' OR last_name LIKE '%#{v}%'") })
      @finder.filter(filter, 'John')
      assert @finder.filtering?, 'Should now be filtering!'
      assert_not_equal @finder.scope, Person.all, 'Scope should have been modified'
      results = @finder.results
      assert_equal 2, results.size, 'Should have found both people, since John is present as first name for one, and last name for the other'

      @finder.filter(filter, 'Jane')
      results = @finder.find!
      assert_equal 1, results.size, 'Should have found only Jane this time'
      assert_equal 'Jane', results.first.first_name
    end

    def test_paginate
      @finder.paginate(offset: 0, size: -1)
      assert_nil @finder.pager, 'Should not have created a pager'

      @finder.paginate(offset: 1, size: 1)
      assert_not_nil @finder.pager, 'Should have created a pager'
      assert_equal 1, @finder.pager.offset
      assert_equal 1, @finder.pager.size
    end

    def test_results
      results = @finder.results
      assert_equal 2, results.size, 'Should have selected everyone'
      assert results.loaded?, 'Should have preloaded the results'

      @finder.paginate(offset: 1, size: 1)
      results = @finder.results
      assert_equal results, @finder.results, 'Should keep sending the same object, not recalculating'

      results = @finder.find! # force reload
      assert_equal 1, results.size, 'Should have size of the page'
      assert_equal Person.last, results.first, 'Should have the last person created'
    end

    def test_find!
      results = @finder.find!
      assert_not_empty results, 'Should have selected something'

      @finder.paginate(offset: 1, size: 1)
      new_results = @finder.find!
      assert_not_equal results, new_results, 'Should have recalculated our stuff'
    end
  end
end
