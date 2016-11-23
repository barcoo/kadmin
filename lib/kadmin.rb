# Core
require 'kadmin/configuration'
require 'kadmin/error'
require 'kadmin/auth'
require 'kadmin/presenter'
require 'kadmin/presentable'

# Rails
require 'kadmin/engine'

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
