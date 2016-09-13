module RailsAdmin
  # Collection of Bootstrap helpers
  module BootstrapHelper
    # @see http://getbootstrap.com/components/#glyphicons-glyphs
    # @param [String] icon the part after glyphicon-
    def glyphicon(icon)
      return content_tag(:span, ' ', class: "glyphicon glyphicon-#{icon}", 'aria-hidden': 'true')
    end

    # @param [Boolean] condition condition of evaluate
    # @param [String] icon_true the glyphicon to use if true
    # @param [String] icon_false the glyphicon to use if false
    def glyphicon_if_else(condition, icon_true, icon_false)
      return condition ? glyphicon(icon_true) : glyphicon(icon_false)
    end

    # Generates HTML for a bootstrap alert message, optionally closable.
    # @param [String] type the type of the alert: danger, success, info, warning, or any alert-<TYPE> defined in your CSS
    # @param [String] text optionally some text if you're not going to pass a block
    # @param [Boolean] dismissible if true, adds a close button to the alert. Requires JS enabled
    # @param [Proc] block optional block to pass if you want add more complex HTML inside
    def alert(type, text: '', dismissible: true, &block)
      css_classes = %W(alert alert-#{type})
      css_classes << 'alert-dismissible' if dismissible

      block_content = capture(&block)

      html = nil
      unless block_content.blank? && text.blank?
        html = content_tag(:div, '', class: css_classes.join(' '), role: 'alert') do
          content = text.safe_join

          if dismissible
            button = button_tag(type: 'button', class: 'close', 'data-dismiss': 'alert') do
              content_tag(:span, '&times', {}, false)
            end
            content.concat(button)
          end

          content.concat(capture(&block)) if block_given?
        end
      end

      return html
    end

    # @param [Hash, String] url_options anything accepted by link_to and image_tag
    # @param [Integer] max_height maximum height of the thumbnail
    def thumbnail_link(url_options, max_height)
      return link_to(image_tag(url_options), url_options, class: 'thumbnail', style: "max-height: #{max_height}px", target: 'new')
    end
  end
end
