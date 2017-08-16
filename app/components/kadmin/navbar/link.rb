# frozen_string_literal: true

module Kadmin
  # TODO: Figure out how to have access to a properly scoped routing proxy
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

      # @return [Rails::Engine] only pass if you want to access engine routes
      attr_reader :engine

      # @param [String] text the link text; can be HTML
      # @param [String, Proc] path the linked path; if a Proc, will get evaluated everytime when calling the reader
      # @param [Array<String>] css_classes list of additional CSS classes
      # @return [Rails::Application] app application providing URL helpers; if you're in an engine, pass your engine
      def initialize(text:, path:, engine: nil, css_classes: [])
        @text = text.freeze
        @path = path.freeze
        @css_classes = Array.wrap(css_classes).dup.freeze
        @engine = engine || Rails.application
      end

      # Generates HTML for use in the main Kadmin layout to build the navigation sidebar
      class Presenter < Kadmin::Presenter
        # Generates HTML to present the section
        # @return [ActiveSupport::SafeBuffer] safe HTML to display
        def generate(captured, **)
          path = self.path

          if self.path.respond_to?(:call)
            router = self.engine.routes.url_helpers
            path = self.path.call(router)
          end

          css_classes = self.css_classes
          css_classes = self.css_classes.dup << 'active' if @view.controller.request.path == path

          contents = @view.link_to(self.text.to_s.html_safe, path)
          contents << captured if captured.present?

          return %(<li class="#{css_classes.join(' ')}">#{contents}</li>).html_safe
        end
      end
    end
  end
end
