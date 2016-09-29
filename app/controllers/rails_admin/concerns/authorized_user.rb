module RailsAdmin
  module Concerns
    module AuthorizedUser
      extend ActiveSupport::Concern

      included do
        if respond_to?(:helper_method)
          helper_method :current_user
          helper_method :authorized_user
        end
      end

      # @!group before_action

      # Add as a before_action whenever you wish to authorize a user for a particular
      # resource. The app provided user model will perform authorization of the resource.
      # @see RailsAdmin::Auth::User
      # @example
      #   before_action :authorize, except: [:index] # exclude index from authorization
      def authorize
        if logged_in?
          unless authorized?
            redirect_to RailsAdmin::Engine.routes.url_helpers.auth_unauthorized_path
          end
        else
          redirect_to RailsAdmin::Engine.routes.url_helpers.auth_login_path(origin: request.path)
        end
      end

      # @!endgroup

      # @!group View Helpers

      # @return [String] the current user identifier. Historically called current_user
      def current_user
        session[RailsAdmin::AuthController::SESSION_KEY]
      end

      # @see RailsAdmin::Concerns::AuthorizedUser#current_user
      # @return [RailsAdmin::Auth::User] instance of the user identified by current_user
      def authorized_user
        return RailsAdmin::Auth.users.get(current_user)
      end

      # @!endgroup

      # @!group Helpers

      # @return [Boolean] true if the user is logged in, false otherwise
      def logged_in?
        return current_user.present?
      end

      # @see RailsAdmin::Auth::User
      # @return [Boolean] true if the user is authorized in, false otherwise
      def authorized?
        return authorized_user&.authorized?(request)
      end

      # @!endgroup
    end
  end
end
