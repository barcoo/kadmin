# Core
require 'kadmin/configuration'
require 'kadmin/error'
require 'kadmin/auth'

# Rails
require 'kadmin/engine'

# Components
require 'kadmin/form'
require 'kadmin/finder'
require 'kadmin/pagination'
require 'kadmin/navigation'

module Kadmin
  class << self
    delegate :logger, :logger=, to: :config

    def config
      return @config ||= Kadmin::Configuration.new
    end

    def configure
      yield(config) if block_given?
      return config
    end
  end
end
