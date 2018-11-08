# frozen_string_literal: true

require 'test_helper'

module Kadmin
  module Auth
    class UserStoreTest < ActiveSupport::TestCase
      def setup
        super
      end

      def test_load_users
        users = []
        rand(1..10).times do |index|
          users << { "email" => index.to_s, "admin": "true" }
        end
        h = {
          "organizations" => ['A'],
          "users" => users
        }

        @file = Tempfile.new
        @file.write(h.to_yaml)
        @file.close

        store = Kadmin::Auth::UserStore.new(@file.path)
        assert store.exists?(users.sample['email'])
      end

      def test_load_organizations
        random_array = Array.new(rand(1..10)) { |i| i.to_s }
        h = {
          "organizations" => random_array,
          "users" => []
        }

        @file = Tempfile.new
        @file.write(h.to_yaml)
        @file.close

        assert_equal 0, Kadmin::Organization.count
        Kadmin::Auth::UserStore.new(@file.path)
        assert_equal h['organizations'].size, Kadmin::Organization.count
      end
    end
  end
end
