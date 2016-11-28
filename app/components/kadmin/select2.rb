# frozen_string_literal: true
module Kadmin
  class Select2
    include Kadmin::Presentable

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

    def initialize(options = {})
      @placeholder = options[:placeholder].to_s.freeze
      extract_ajax_options!(options).freeze unless options.blank?
    end

    def extract_ajax_options!(options)
      @data_url = options[:data_url]
      @filter_param = options[:filter_param]
      @display_property = options.fetch(:display_property, 'text')
      @value_property = options.fetch(:value_property, 'value')

      raise ArgumentError, 'missing data URL for remote fetching' if @data_url.blank?
    end
    private :extract_ajax_options!
  end
end
