module RailsAdmin
  module Auth
    class Configuration
      OAuthCredentials = Struct.new(:id, :secret)

      # @return [RailsAdmin::Auth::Configuration::OAuthCredentials] credentials for OAuth2 authentication; if absent, fallback to :developer provider
      attr_accessor :oauth_credentials

      # @return [Class<RailsAdmin::Auth::User>] class to use for authenticated users (mostly for resource authorization)
      attr_accessor :user_class

      # @return [Class<RailsAdmin::Auth::UserStore>] class for user lookup/registration
      attr_accessor :user_store_class

      def initialize
        @oauth_credentials = nil
        @user_class = RailsAdmin::Auth::User
        @user_store_class = RailsAdmin::Auth::UserStore
        @enabled = false
      end

      # @return [Boolean] true if enabled, false otherwise
      def enabled?
        return @enabled
      end

      def enable!
        RailsAdmin::Auth.enable!
        @enabled = true
      end

      def disable!
        @enabled = false
      end
    end
  end
end
