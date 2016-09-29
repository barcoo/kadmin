# Third party dependency
require 'omniauth-google-oauth2'

# Core files
require 'rails_admin/auth/unauthorized_error'
require 'rails_admin/auth/configuration'
require 'rails_admin/auth/user'
require 'rails_admin/auth/user_store'

module RailsAdmin
  module Auth
    class << self
      def users
        @users ||= config.user_store_class.new
      end

      def config
        return @config ||= RailsAdmin::Auth::Configuration.new
      end

      def configure
        yield(config) if block_given?
        return config
      end

      def enable!
        unless @enabled
          @enabled = true

          OmniAuth.config.logger = RailsAdmin.logger
          OmniAuth.config.path_prefix = File.join(RailsAdmin.config.mount_path, OmniAuth.config.path_prefix)

          provider_args = case omniauth_provider
          when :google_oauth2
            [:google_oauth2, config.oauth_credentials.id, config.oauth_credentials.secret]
          else
            [:developer, fields: [:email]]
          end

          Rails.application.config.middleware.use OmniAuth::Builder do
            provider(*provider_args)
          end
        end
      end

      def omniauth_provider
        return config.oauth_credentials.present? ? :google_oauth2 : :developer
      end
    end
  end
end
