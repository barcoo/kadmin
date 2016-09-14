require 'omniauth'

module RailsAdmin
  module Omniauth
    # @return [String, Hash] link_to params for the Omniauth callback link
    mattr_accessor(:provider_link) { '/auth/development' }

    def enable_development_strategy!(options = {})
      require 'omniauth/strategies/development'
      require 'rails_admin/omniauth/user'

      unless @enabled
        @enabled = true

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :development, options
        end
      end
    end
    module_function :enable_development_strategy!
  end
end
