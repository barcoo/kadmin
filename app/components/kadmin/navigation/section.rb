# frozen_string_literal: true
module Kadmin
  module Navigation
    # A navigation section is a way of grouping several navigation links
    class Section
      include Kadmin::Presentable

      # @return [String] title displayed for the section (or HTML)
      attr_reader :title

      # @return [Hash<String, Kadmin::Navigation::Link>] links in the section, with keys being the link's path
      attr_reader :links

      def initialize(title:, links:)
        @title = title.freeze
        @links = create_links_hash(links).freeze
      end

      def create_links_hash(links)
        return Array.wrap(links).each_with_object({}) do |link, hash|
          hash[link.path] = link.freeze
        end
      end
      private :create_links_hash

      # Generates HTML for use in the main Kadmin layout to build the navigation sidebar
      class Presenter < Kadmin::Presenter
        # Generates a list item with the section text as header, and a sub-list for the links
        # @return [ActiveSupport::SafeBuffer] safe HTML to display
        def generate(**)
          request_path = @view.controller.request.path
          css_class = 'active open' if self.links.key?(request_path)
          section_links = @view.safe_join(self.links.values.map { |link| link.present(@view).render })

          return "<li class='#{css_class}'><a>#{self.title} <i class='fa arrow'></i></a><ul>#{section_links}</ul></li>".html_safe
        end
      end
    end
  end
end
