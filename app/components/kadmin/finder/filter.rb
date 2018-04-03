# frozen_string_literal: true

module Kadmin
  class Finder
    class Filter
      attr_accessor :name
      attr_reader :value

      def initialize(name, scope)
        @name = name
        @scope = scope
        @value = nil
      end

      def apply(scope, value)
        @value = value
        scope.merge(scope.instance_exec(value, &@scope))
      end
    end
  end
end
