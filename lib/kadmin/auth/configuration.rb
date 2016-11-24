module Kadmin
  module Auth
    class Configuration
      OAuthCredentials = Struct.new(:id, :secret)

      # @return [Kadmin::Auth::Configuration::OAuthCredentials] credentials for OAuth2 authentication; if absent, fallback to :developer provider
      attr_accessor :oauth_credentials

      # @return [Class<Kadmin::Auth::User>] class to use for authenticated users (mostly for resource authorization)
      attr_accessor :user_class

      # @return [Class<Kadmin::Auth::UserStore>] class for user lookup/registration
      attr_accessor :user_store_class

      def initialize
        @oauth_credentials = nil
        @user_class = Kadmin::Auth::User
        @user_store_class = Kadmin::Auth::UserStore
        @enabled = false
      end

      # @return [Boolean] true if enabled, false otherwise
      def enabled?
        return @enabled
      end

      # Enables authentication and adds OmniAuth middlewares
      def enable!
        unless @enabled
          append_omniauth_middleware
          @enabled = true
        end
      end

      # Disables authentication and removes OmniAuth middlewares
      def disable!
        if @enabled
          delete_omniauth_middleware
          @enabled = false
        end
      end

      def append_omniauth_middleware
        OmniAuth.config.logger = Kadmin.logger
        OmniAuth.config.path_prefix = File.join(Kadmin.config.mount_path, OmniAuth.config.path_prefix)

        provider_args = case Kadmin::Auth.omniauth_provider
        when :google_oauth2
          [:google_oauth2, @oauth_credentials.id, @oauth_credentials.secret]
        else
          [:developer, fields: [:email]]
        end

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider(*provider_args)
        end
      end
      private :append_omniauth_middleware
    end
  end
end
