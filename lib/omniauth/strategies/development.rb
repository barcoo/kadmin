require 'omniauth'

module OmniAuth
  module Strategies
    class Development
      include OmniAuth::Strategy

      option :fields, [:email]

      def request_phase
        if options[:on_login]
          options[:on_login].call(self.env)
        else
          OmniAuth::Form.build(title: 'Authentication', url: callback_path) do |f|
            f.text_field 'Email', 'auth_key'
          end.to_response
        end
      end

      def callback_phase
        return fail!(:invalid_credentials) unless user
        super
      end

      def other_phase
        call_app!
      end

      uid { nil }
      info { user.to_h }

      def user
        @user ||= model.new(request['auth_key'])
      end

      def model
        options[:model] || RailsAdmin::Omniauth::User
      end
    end
  end
end
