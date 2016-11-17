module Kadmin
  module Navigation
    class Section
      # @return [String] text displayed for the section (or HTML)
      attr_reader :text

      # @return [Hash<String, Kadmin::Navigation::Link>] links in the section, with keys being the link's path
      attr_reader :links

      def initialize(text:, links:)
        @text = text.freeze
        @links = create_links_hash(links).freeze
      end

      def present(view_context)
        request_path = view_context.controller.request.path
        css_class = 'active open' if @links.key?(request_path)
        section_links = @links.values.map { |link| link.present(view_context) }.join('')

        return "<li class='#{css_class}'><a>#{@text} <i class='fa arrow'></i></a><ul>#{section_links}</ul></li>".html_safe
      end

      def create_links_hash(links)
        return Array.wrap(links).each_with_object({}) do |link, hash|
          hash[link.path] = link.freeze
        end
      end
      private :create_links_hash
    end
  end
end
