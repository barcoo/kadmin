# frozen_string_literal: true

module Kadmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [String] the path the engine is mounted at (used for authentication routes)
    attr_accessor :mount_path

    # @return [Array<Kadmin::Navbar::Section, Kadmin::Navbar::Link>] list of admin links or sections
    attr_accessor :navbar_items

    # @return [Boolean] if true, any Kadmin::ApplicationController will catch errors and display a custom page
    attr_accessor :handle_errors

    def initialize
      @mount_path = '/admin'
      @logger = Rails.logger
      @navbar_items = []
      @handle_errors = false
    end

    def add_navbar_items(*items)
      items.each do |item|
        index = @navbar_items.bsearch_index { |navbar_item| navbar_item.text >= item.text }
        @navbar_items.insert(index || @navbar_items.size, item)
      end
    end

    # filter available nav sections with the user's accept string
    def navbar_items_for_user(user)
      return [] if user.blank? # no user, no links
      return @navbar_items if user.accept.blank? # no accept array -> everything is accepted
      return @navbar_items.select do |navbar_item|
        user.accept.any? { |accept_string| navbar_item.text =~ /#{accept_string.to_s.split('_').first}/i }
      end
    end
  end
end
