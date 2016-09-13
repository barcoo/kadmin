module RailsAdmin
  module NavigationHelper
    # Generates HTML for a bootstrap navigation link
    # @param [String] title the navigation text
    # @param [Hash, String] path the path for the link
    # @param [Proc] block optional block to include content within the link
    def nav_link_to(title, path, &block)
      css_classes = []
      css_classes << 'active' if request.path.starts_with?(path)
      return content_tag(:li, link_to(title, path, &block), class: css_classes.join(' '))
    end

    # Generates a navigation drop down for bootstrap
    # @param [String] prompt dropdown prompt
    # @param [Array<Hash,String>] links list of links to add within the dropdown
    def dropdown(prompt, links = [])
      button_content = content_tag(:span, '', class: 'caret').prepend(prompt)
      button = button_tag(button_content, type: 'button', data: { toggle: 'dropdown' }, class: 'btn btn-default')
      list = content_tag(:ul, '', class: 'dropdown-menu') do
        links.reduce(ActiveSupport::SafeBuffer.new) do |buffer, link|
          buffer + content_tag(:li, link)
        end
      end

      return content_tag(:div, button + list, class: 'dropdown', style: 'display: inline-block;')
    end
  end
end
