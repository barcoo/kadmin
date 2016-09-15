module RailsAdmin
  module Concerns
    # Include in your controller, and use authorized? as a before action.
    # @example
    #   before_action :authorized?, only: [:index]
    module Authorization
      extend ActiveSupport::Concern

      included do
        helper_method :current_user
      end

      # @return [String] identifier of the current user
      def current_user
        return @current_user ||= session['rails_admin.user']
      end

      def authorized?
        if current_user.blank?
          redirect_to auth_login_path
          return
        end

        unless authorize
          render template: 'rails_admin/unauthorized', layout: 'rails_admin/application'
          return
        end
      end

      # Should overload to provide per-resource authorization
      # Raise RailsAdmin::Errors::Authorization when unauthorized.
      def authorize
      end
      protected :authorize
    end
  end
end
