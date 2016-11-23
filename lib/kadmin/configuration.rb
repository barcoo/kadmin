# frozen_string_literal: true
module Kadmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [String] the path the engine is mounted at (used for authentication routes)
    attr_accessor :mount_path

    # @return [Array<Kadmin::Navbar::Section, Kadmin::Navbar::Link>] list of admin links or sections
    attr_accessor :navbar_items

    def initialize
      @mount_path = '/admin'
      @logger = Rails.logger
      @navbar_items = []
    end

    def add_navbar_items(*items)
      items.each do |item|
        index = @navbar_items.bsearch_index { |navbar_item| navbar_item.text >= item.text }
        @navbar_items.insert(index || @navbar_items.size, item)
      end
    end
  end
end
