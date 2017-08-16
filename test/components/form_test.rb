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

    class MainForm < Kadmin::Form
      delegate_association :items, to: 'Kadmin::FormTest::ItemForm'
      delegate_attributes :owner
    end

    class ItemForm < Kadmin::Form
    end

    class Package
      include ActiveModel::Model
      attr_accessor :id, :owner

      def persisted?
        return !self.id.nil?
      end

      def items_attributes(item_attributes)
        item_attributes.each do |attributes|
        end
      end
    end

    class Item
      include ActiveModel::Model
      attr_accessor :id, :name, :weight, :package_id

      def persisted?
        return !self.id.nil?
      end
    end
  end
end
