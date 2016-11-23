# frozen_string_literal: true
module Kadmin
  module Navigation
    # A navigation section is a way of grouping several navigation links
    class Section
      include Kadmin::Presentable

      # @return [String] title displayed for the section (or HTML)
      attr_reader :text

      # @return [Hash<String, Kadmin::Navigation::Link>] links in the section, with keys being the link's path
      attr_reader :links

      def initialize(text:, links:)
        @text = text.freeze
        @links = links.freeze
      end

      # Generates HTML for use in the main Kadmin layout to build the navigation sidebar
      class Presenter < Kadmin::Presenter
        # Generates a list item with the section text as header, and a sub-list for the links
        # @return [ActiveSupport::SafeBuffer] safe HTML to display
        def generate(**)
          request_path = @view.controller.request.path
          section_links = ActiveSupport::SafeBuffer.new
          css_class = nil

          binding.pry

          self.links.each do |link|
            link_presenter = link.present(@view)
            section_links << link_presenter.render
            css_class = 'active open' if css_class.nil? && link_presenter.path == request_path
          end

          return "<li class='#{css_class}'><a>#{self.text} <i class='fa arrow'></i></a><ul>#{section_links}</ul></li>".html_safe
        end
      end
    end
  end
end
