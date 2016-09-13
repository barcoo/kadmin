module RailsAdmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [Loyalty::Concerns::Authorization] An object implementing the Loyalty::Concerns::Authorization interface
    attr_accessor :authorization_concern

    # @return [String] Path to the main app's admin section
    attr_accessor :admin_path

    # @return [String] Google client ID used for OAuth2 authorization
    attr_accessor :google_client_id

    # @return [String] Google secret key used for OAuth2 authorization
    attr_accessor :google_secret_key

    def initialize
      @admin_path = '/admin'
      @authorization_concern = Loyalty::Concerns::Authorization
    end
  end
end
