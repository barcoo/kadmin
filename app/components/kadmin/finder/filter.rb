# frozen_string_literal: true

module Kadmin
  class Finder
    class Filter
      attr_accessor :name
      attr_reader :value

      def initialize(name:, scope:)
        @helpers = Helpers.new
        @name = name
        @scope = scope
        @value = nil
      end

      def apply(scope, value)
        @value = value
        @helpers.instance_exec(scope, value, &@scope)
      end

      class Helpers
        def quote(string)
          ActiveRecord::Base.connection.quote(string)
        end

        def fuzz(string)
          fuzzed = string
          fuzzed = "%#{fuzzed}" unless string.start_with?('%')
          fuzzed = "#{fuzzed}%" unless string.end_with?('%')

          return fuzzed
        end
      end
    end
  end
end
