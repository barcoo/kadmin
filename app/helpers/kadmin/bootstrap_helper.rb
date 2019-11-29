module Kadmin
  # Collection of Bootstrap helpers
  module BootstrapHelper
    # @see Font-Awesome icons: http://fontawesome.io/icons/
    # @param [String] the name of the icon you want
    def glyphicon(icon)
      return "<i class='fa fa-#{icon}' aria-hidden='true'></i>".html_safe
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

    # Generates help assitance using bootstrap i.e. * for mendatory feilds, help icon and popover for help
    # @param [String] label text for the view
    # @param [String] label_for is ID of the html element for which we are displaying label.
    # @param [Boolean] Display the red asteric to indicate mendatory field.
    # @param [Boolean] to decide weither we need to display the help iocn or not
    # @param [String] Title of the popover
    # @param [String] Body text of popover
    # @param [String] classname for the label.
    def help_assistance(label, label_for = "", required = false, display_help = true, title = "", message = "", label_class = 'control-label')
      label = t(label)
      label = label.html_safe

      require_html = required ? '<span class="required-field"><span>':''
      icon_html = "<i class='fa fa-question-circle' style='color:green'></i>"

      display_message = ""
      if  display_help
        message = t(message)
        message = message.gsub('"', '\"')
        message = message.gsub("'", "\'")
        html_message = message.html_safe

        title = t(title)
        title = title.html_safe
        display_message = "<span data-toggle='popover' title='#{title}' data-placement='top' data-trigger='hover' data-content='#{html_message}'>#{icon_html}</span>"
      end

      return "<label for='#{label_for}' class='#{label_class}'' >#{require_html}#{label} #{display_message}</label>".html_safe
    end
  end
end
