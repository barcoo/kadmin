require 'test_helper'

module Kadmin
  module Navbar
    class Link
      def test_path
        link = Kadmin::Navbar::Link.new(text: 'text', path: 'textual_path')
        assert_equal 'textual_path', link.path, 'Should return the actual link'

        counter = 0
        dynamic_link = Kadmin::Navbar::Link.new(text: 'dynamic', path: -> { counter += 1 })
        assert_equal 1, dynamic_link.path, 'Should have executed the proc'
        assert_equal 2, dynamic_link.path, 'Should have executed the proc again'
      end

      # Simple demo of how to use Kadmin::Presenter::TestCase
      class PresenterTest < Kadmin::Presenter::TestCase
        def test_render
          link = Kadmin::Navbar::Link.new(text: 'text', path: 'my_path', css_classes: %w(icon plus))
          present link
          assert_select 'li.icon.plus > a[href="my_path"]', count: 1, text: 'text'
        end

        def test_render_active
          # fake path to be the same as the link
          self.controller.request.path = 'active_path'
          link = Kadmin::Navbar::Link.new(text: 'text', path: 'active_path', css_classes: 'other')
          present link
          assert_select 'li.active.other', count: 1
        end
      end
    end
  end
end
