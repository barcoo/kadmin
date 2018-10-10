# Third party dependency
require 'omniauth-google-oauth2'

# Core files
require 'kadmin/auth/unauthorized_error'
require 'kadmin/auth/configuration'
require 'kadmin/auth/user'
require 'kadmin/auth/user_store'

module Kadmin
  module Auth
    class << self
      attr_accessor :test_user

      def users
        @users ||= config.user_store_class.new
      end

      def config
        return @config ||= Kadmin::Auth::Configuration.new
      end

      def configure
        yield(config) if block_given?
        return config
      end

      def omniauth_provider
        return config.oauth_credentials.present? ? :google_oauth2 : :developer
      end
    end
  end
end
