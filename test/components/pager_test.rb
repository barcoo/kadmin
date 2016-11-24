require 'test_helper'

module Kadmin
  class PagerTest < ActiveSupport::TestCase
    def setup
      super
      @pager = Kadmin::Pager.new(size: 10, offset: 10)
    end

    def test_initialize
      assert_raises(Kadmin::Error, 'offset must be >= 0') { Kadmin::Pager.new(size: 1, offset: -1) }
      assert_raises(Kadmin::Error, 'size must be > 0') { Kadmin::Pager.new(size: 0, offset: 1) }

      assert_equal 10, @pager.size
      assert_equal 10, @pager.offset
      assert_equal 10, @pager.total, 'By default assigns the offset as total guess'
      assert_equal 1, @pager.current_page
    end

    def test_paginate
    end

    def test_offset_at
      assert_equal @pager.offset, @pager.offset_at, 'Should return the offset for the current page'
      assert_equal 20, @pager.offset_at(2), 'Should return 2 * pager.size'
    end

    def test_current_page?
      assert @pager.current_page?(1), 'Since offset is 10, we are on page 1'
      assert !@pager.current_page?(2), 'Should not mark as on page 2'
    end

    def test_contains?
      @pager.total = 11 # increase total so we have a second page
      assert @pager.contains?(1), 'Should have page 1, since this is the current page'
      assert @pager.contains?(0), 'Previous pages should be contained too'
      assert !@pager.contains?(2), 'The offset for page 2 is greater than what we consider the total amount of items'
    end

    def test_total=
      @pager.total = 30
      assert_equal 30, @pager.total
      assert_equal 3, @pager.pages, 'Should have 3 pages based on total and page size'
    end

    def test_page_size
      @pager.total = 11 # so we get a second page
      assert_equal 1, @pager.page_size, 'Only 1 item on this page'
      assert_equal 10, @pager.page_size(0), '10 expected items on page 0'
      assert_equal 0, @pager.page_size(30), 'No expected items on page 30'
    end

    def test_next_page?
      assert !@pager.next_page?, 'Current page is 1, and there is no next page as total is 10, and offset is currently 10'
      assert !@pager.next_page?(0), 'There is no page after page 0'

      @pager.total = 11
      assert @pager.next_page?(0), 'There is a page after page 0 now'
    end

    def test_previous_page?
      assert @pager.previous_page?, 'There is a previous page, page 0'
      assert !@pager.previous_page?(0), 'There is no page -1'
    end
  end
end
