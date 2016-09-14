module RailsAdmin
  class Configuration
    # @return [Logger] An instance of a Ruby compatible logger
    attr_accessor :logger

    # @return [RailsAdmin::Concerns::Authorization] an object implementing the RailsAdmin::Concerns::Authorization interface
    attr_accessor :authorization_concern

    # @return [String] path to the main app's admin section
    attr_accessor :admin_path

    # @return [String] fallback URL to use when no redirect URL is provided on login/logout
    attr_accessor :fallback_redirect_url

    def initialize
      @admin_path = '/admin'
      @authorization_concern = RailsAdmin::Concerns::Authorization
      @logger = Rails.logger
      @fallback_redirect_url = '/'
    end
  end
end
