require 'test_helper'

module Kadmin
  module Navbar
    class Section
      class PresenterTest < Kadmin::Presenter::TestCase
        def setup
          @links = [
            flexmock(Kadmin::Navbar::Link.new(text: 'link1', path: 'path1')),
            flexmock(Kadmin::Navbar::Link.new(text: 'link2', path: 'path2'))
          ]

          @links.each do |link|
            link.should_receive(:present).and_return(link)
            link.should_receive(:render).and_return('')
          end
          @section = Kadmin::Navbar::Section.new(id: 'Section', text: 'text', links: @links, css_classes: %w(icon plus))
        end

        def test_render
          present @section
          assert_select 'li.icon.plus > a', count: 1, text: 'text'
          assert_select 'li.icon.plus > ul', count: 1

          @links.each do |link|
            assert_spy_called link, { times: 1 }, :present, self
            assert_spy_called link, { times: 1 }, :render
          end
        end

        def test_render_open
          # fake section to be current one
          self.controller.class.class_exec do
            class << self
              attr_reader :navbar_section
            end
            @navbar_section = 'Section'
          end

          present @section
          assert_select 'li.active.open.icon.plus', count: 1, text: 'text'
        end
      end
    end
  end
end
