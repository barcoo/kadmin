require 'rails_admin/configuration'
require 'rails_admin/error'
require 'rails_admin/engine'

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
