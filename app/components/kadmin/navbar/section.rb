# frozen_string_literal: true

module Kadmin
  # TODO: Clearly some functionality between Navbar::Link and Navbar::Section is shared and
  # could be refactored into Navbar::Item one day.
  module Navbar
    # A navigation section is a way of grouping several navigation links
    class Section
      include Kadmin::Presentable

      # @return [Object] unique ID for the section; for a gem, it is recommended to use the top level namespace
      attr_reader :id

      # @return [String] title displayed for the section (or HTML)
      attr_reader :text

      # @return [Hash<String, Kadmin::Navbar::Link>] links in the section, with keys being the link's path
      attr_reader :links

      # @return [Array<String>] list of additional CSS classes
      attr_reader :css_classes

      def initialize(id:, text:, links:, css_classes: [])
        @id = id.to_s.freeze
        @text = text.freeze
        @links = links.freeze
        @css_classes = Array.wrap(css_classes).dup.freeze
      end

      # Generates HTML for use in the main Kadmin layout to build the navigation sidebar
      class Presenter < Kadmin::Presenter
        # Generates a list item with the section text as header, and a sub-list for the links
        # @return [ActiveSupport::SafeBuffer] safe HTML to display
        def generate(captured, **)
          current_section_id = @view.controller.class.try(:navbar_section).to_s
          section_links = ActiveSupport::SafeBuffer.new
          css_classes = self.css_classes.dup
          css_classes = css_classes << 'active open' if !current_section_id.nil? && current_section_id == self.id

          self.links.each { |link| section_links << link.present(@view).render }

          return "<li class='#{css_classes.join(' ')}'><a>#{self.text} <i class='fa arrow'></i></a><ul>#{section_links}</ul>#{captured}</li>".html_safe
        end
      end
    end
  end
end
