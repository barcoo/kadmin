# frozen_string_literal: true

module Kadmin
  class Presenter
    # Test class for Presenters. While this will not be common, it highlights how much
    # easier presenters are to test.
    # TODO: When a use case presents itself, modify to handle JSON or other outputs that are not HTML.
    class TestCase < ActionView::TestCase
      def present(presentable)
        renderable = case presentable
        when Kadmin::Presenter
          presentable
        when Kadmin::Presentable
          presentable.present
        end

        raise ArgumentError, "don't know how to render #{presentable}" if renderable.nil?
        @rendered = renderable.render(view: self)
        return @rendered
      end
    end
  end
end
