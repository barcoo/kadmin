module Kadmin
  module Navigation
    class Link
      # @return [String] text of the link
      attr_reader :text

      # @return [String, URL] path/URL for the given link
      attr_reader :path

      # @return [Array<String>] list of additional CSS classes
      attr_reader :css_classes

      def initialize(text:, path:, css_classes: [])
        @text = text.freeze
        @path = path.freeze
        @css_classes = Array.wrap(css_classes).freeze
      end

      # Generates HTML to present the section
      # @param [ActiveView::Base] view_context the context to present the section in
      # @return [ActiveSupport::SafeBuffer] safe HTML to display
      def present(view_context)
        css_classes = @css_classes
        css_classes = @css_classes.dup << 'active' if view_context.controller.request.path == @path
        contents = view_context.link_to(@text, @path)

        return %(<li class="#{css_classes.join(' ')}">#{contents}</li>)
      end
    end
  end
end
