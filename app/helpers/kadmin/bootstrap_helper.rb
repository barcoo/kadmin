# frozen_string_literal: true

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
      return link_to(
        image_tag(url_options),
        url_options,
        class: 'thumbnail',
        style: "max-height: #{max_height}px",
        target: 'new'
      )
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

    # Custom label generator using bootstrap i.e. * for mendatory feilds, help icon and popover for help
    # @param [String] key identifier for the help label / input field
    # @param [Hash] options options for the help label
    def create_custom_label(key, options = {})
      defaults = {
        label_for: "#{key}",
        required: false,
        display_help: true,
        title: ".#{key}.title",
        message: ".#{key}.message",
        label_class: 'control-label',
        data_placement: 'top'
      }
      options = defaults.merge(options)

      label = t(".#{key}.label")
      label = label.html_safe

      require_html = options[:required] ? '<span class="required-field"><span>' : ''
      icon_html = "<i class='fa fa-question-circle' style='color:green'></i>"

      display_message = ''
      if options[:display_help]
        message = t(options[:message])
        message = message.gsub('"', '\"')
        message = message.gsub("'", "\'")
        html_message = message.html_safe

        title = t(options[:title])
        title = title.html_safe

        display_message = "<span data-toggle='popover' title='#{title}' data-placement='#{options[:data_placement]}' data-trigger='hover' data-content='#{html_message}'>#{icon_html}</span>"
      end

      return "<label for='#{options[:label_for]}' class='#{options[:label_class]}'>#{require_html}#{label} #{display_message}</label>".html_safe
    end
  end
end
