# frozen_string_literal: true
module Kadmin
  # Provide helpers for displaying alerts, as well as matching those alerts to
  # different flash keys.
  module AlertHelper
    # Generates HTML for a bootstrap alert message, optionally closable.
    # @param [String] type the type of the alert: danger, success, info, warning, or any alert-<TYPE> defined in your CSS
    # @param [Hash] options options to customize the alert
    # @option options [String] content ('') text to show if you're not going to pass a block
    # @option options [Boolean] dismissible (true) if true, adds a close button to the alert. Requires JS enabled
    # @param [Proc] block optional block to pass if you want add more complex HTML inside
    def alert(type, options = {}, &block)
      dismissible = options.fetch(:dismissible, true)
      text_content = options.fetch(:content, '')

      css_classes = %W(alert alert-#{type})
      css_classes << 'alert-dismissible' if options.fetch(:dismissible, true)
      block_content = capture(&block) if block_given?

      return content_tag(:div, '', class: css_classes.join(' '), role: 'alert') do
        content = text_content.html_safe

        if dismissible
          button = button_tag(type: 'button', class: 'close', 'data-dismiss': 'alert') do
            content_tag(:span, '&times', {}, false)
          end
          content.concat(button)
        end

        content.concat(block_content.html_safe) unless block_content.blank?
        content
      end
    end

    Type = Struct.new(:flash_keys, :css_class, :glyphicon)
    TYPES = [
      Type.new(%w(danger alert), 'danger', 'exclamation-sign'),
      Type.new(['success'], 'success', 'ok-sign'),
      Type.new(%w(notice info), 'info', 'info-sign'),
      Type.new(%w(warn warning), 'warning', 'question-sign')
    ].freeze
    def render_flash_alerts
      alerts = AlertHelper::TYPES.map do |type|
        next unless type.flash_keys.any? { |key| flash[key].present? }
        render_flash_alert(type)
      end.compact

      return safe_join(alerts)
    end

    def render_flash_alert(type, &_block)
      messages = type.flash_keys.map { |key| Array.wrap(flash[key]).compact }.flatten
      return '' if messages.blank?

      wrapped = messages.map { |message| content_tag(:p, glyphicon(type.glyphicon) + " #{message}") }.join('')
      return alert(type.css_class, content: wrapped)
    end
  end
end
