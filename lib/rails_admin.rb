# Utility packages
require 'rails_admin/utils'
require 'rails_admin/error'

module RailsAdmin
  class << self
    delegate :logger, :logger=, to: :config

    def config
      return @config ||= RailsAdmin::Configuration.new
    end

    def configure
      yield(config) if block_given?
      return config
    end
  end
end
