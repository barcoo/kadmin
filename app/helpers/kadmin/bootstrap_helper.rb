module Kadmin
  # Collection of Bootstrap helpers
  module BootstrapHelper
    # @see http://getbootstrap.com/components/#glyphicons-glyphs
    # @param [String] icon the part after glyphicon-
    def glyphicon(icon)
      return "<span class='glyphicon glyphicon-#{icon}' aria-hidden='true'> </span>".html_safe
    end

    # @param [Boolean] condition condition of evaluate
    # @param [String] icon_true the glyphicon to use if true
    # @param [String] icon_false the glyphicon to use if false
    def glyphicon_if_else(condition, icon_true, icon_false)
      return condition ? glyphicon(icon_true) : glyphicon(icon_false)
    end

    # @param [Hash, String] url_options anything accepted by link_to and image_tag
    # @param [Integer] max_height maximum height of the thumbnail
    def thumbnail_link(url_options, max_height)
      return link_to(image_tag(url_options), url_options, class: 'thumbnail', style: "max-height: #{max_height}px", target: 'new')
    end

    # Generates a navigation drop down for bootstrap
    # @param [String] prompt dropdown prompt
    # @param [Array<Hash,String>] links list of links to add within the dropdown
    def dropdown(prompt, links = [])
      button_content = content_tag(:span, '', class: 'caret').prepend(prompt)
      button = button_tag(button_content, type: 'button', data: { toggle: 'dropdown' }, class: 'btn btn-sm')
      list = content_tag(:ul, '', class: 'dropdown-menu') do
        links.reduce(ActiveSupport::SafeBuffer.new) do |buffer, link|
          buffer + content_tag(:li, link)
        end
      end

      return content_tag(:div, button + list, class: 'dropdown', style: 'display: inline-block;')
    end
  end
end
