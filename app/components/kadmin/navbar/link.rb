# frozen_string_literal: true
module Kadmin
  module Navbar
    # A navigation link for use with the navbar items
    class Link
      include Kadmin::Presentable

      # @return [String] text of the link
      attr_reader :text

      # @return [String] path for the given link
      attr_reader :path

      # @return [Array<String>] list of additional CSS classes
      attr_reader :css_classes

      # @param [String] text the link text; can be HTML
      # @param [String, Proc] path the linked path; if a Proc, will get evaluated everytime when calling the reader
      # @param [Array<String>] css_classes list of additional CSS classes
      def initialize(text:, path:, css_classes: [])
        @text = text.freeze
        @path = path.freeze
        @css_classes = Array.wrap(css_classes).dup.freeze
      end

      # Supports dynamic paths by setting the base property as a Proc
      # @return [String] path for the given link
      def path
        return @path.respond_to?(:call) ? @path.call : @path
      end

      # Generates HTML for use in the main Kadmin layout to build the navigation sidebar
      class Presenter < Kadmin::Presenter
        # Generates HTML to present the section
        # @return [ActiveSupport::SafeBuffer] safe HTML to display
        def generate(captured, **)
          css_classes = self.css_classes
          css_classes = self.css_classes.dup << 'active' if @view.controller.request.path == self.path
          contents = @view.link_to(self.text.to_s.html_safe, self.path)
          contents << captured unless captured.blank?

          return %(<li class="#{css_classes.join(' ')}">#{contents}</li>).html_safe
        end
      end
    end
  end
end
