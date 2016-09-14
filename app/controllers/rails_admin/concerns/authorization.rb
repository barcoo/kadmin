module RailsAdmin
  module Concerns
    # Include in your controller, and use authorized? as a before action.
    # @example
    #   before_action :authorized?, only: [:index]
    module Authorization
      extend ActiveSupport::Concern

      included do
        helper_method :current_user
        rescue_from RailsAdmin::Errors::Authorization, with: :unauthorized
      end

      # @return [String] identifier of the current user
      def current_user
        return session[:admin_user]
      end

      # Should return whether the user is authorized for this particular resource.
      # Use current_user and #request method to figure out.
      # Raise RailsAdmin::Errors::Authorization when unauthorized.
      # @return [Boolean] true if the user is authorized, false otherwise
      def authorized?
        true
      end

      def unauthorized(error)
        RailsAdmin.logger.error(error)
        render template: 'rails_admin/unauthorized'
      end
      protected :unauthorized
    end
  end
end
