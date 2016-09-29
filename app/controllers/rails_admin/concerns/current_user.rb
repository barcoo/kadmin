module RailsAdmin
  module Concerns
    module CurrentUser
      extend ActiveSupport::Concern

      included do
        helper_method :current_user if respond_to?(:helper_method)
      end

      def current_user
        session[RailsAdmin::AuthController::SESSION_KEY]
      end
    end
  end
end
