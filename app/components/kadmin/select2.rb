# frozen_string_literal: true
module Kadmin
  class Select2
    include Kadmin::Presentable

    CSS_CLASS_MARKER = 'kadmin-select2'

    DATA_ATTRIBUTES = [
      :placeholder, :data_url, :filter_param, :display_property, :value_property, :page_size
    ].freeze

    # @return [String] will be used as a placeholder if given
    attr_reader :placeholder

    # NOTE: using this assumes the backend URL uses a Finder object
    # @see Kadmin::Finder
    # @return [String] if given, will set up remote fetching to this URL
    attr_reader :data_url

    # @return [String] the name of the filter param when doing remote fetching
    attr_reader :filter_param

    # @return [String] the name of the display property for the model (if doing remote fetching)
    attr_reader :display_property

    # @return [String] the name of the property used as the selected value
    attr_reader :value_property

    # @return [Integer] the page size value to fetch on each select2 remote fetch
    attr_reader :page_size

    def initialize(options = {})
      @placeholder = options[:placeholder].to_s.freeze
      extract_ajax_options!(options).freeze unless options.blank?
    end

    def extract_ajax_options!(options)
      @data_url = options[:data_url]
      @filter_param = options[:filter_param]
      @display_property = options.fetch(:display_property, 'text')
      @value_property = options.fetch(:value_property, 'id')
      @page_size = options.fetch(:page_size, 10)

      raise ArgumentError, 'missing data URL for remote fetching' if @data_url.blank?
    end
    private :extract_ajax_options!

    def to_data
      {
        'placeholder' => placeholder,
        'ajax--url' => data_url,
        'kadmin--filter-param' => filter_param,
        'kadmin--display-property' => display_property,
        'kadmin--value-property' => value_property,
        'kadmin--page-size' => page_size
      }
    end

    class << self
      def prepare_form_tag_options(options = {}, html_options = {})
        options = options.dup
        select2_options = options.extract!(*DATA_ATTRIBUTES)

        select2 = new(select2_options)

        html_options = { data: {}, class: '' }.merge(html_options)
        html_options[:data].merge!(select2.to_data)
        mark_tag_as_select2!(html_options)

        return options, html_options
      end

      def mark_tag_as_select2!(html_options)
        css_classes = Array.wrap(html_options[:class])
        css_classes << CSS_CLASS_MARKER
        html_options[:class] = css_classes.join(' ')
      end
      private :mark_tag_as_select2!
    end
  end
end
