# frozen_string_literal: true
require 'test_helper'

module Kadmin
  # NOTE: Uses the Person model from the dummy app for testing
  class FormTest < ActiveSupport::TestCase
    def test_initialize
      person = Person.create(first_name: 'first', last_name: 'last', gender: 'm', date_of_birth: 2.years.ago)
      form = Kadmin::Form.new(person)

      assert_equal person, form.model
      assert_empty form.errors
      assert form.valid?
      assert_equal person, form.to_model
    end


  end
end

# movies: movies have a cast (people), genres (tags), and then other info
