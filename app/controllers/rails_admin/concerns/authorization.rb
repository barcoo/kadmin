module RailsAdmin
  module Concerns
    module Authorization
      # @return [String] identifier of the current user
      def current_user
        return session[:admin_user]
      end

      # Should return whether the user is authorized for this particular resource.
      # Use current_user and #request method to figure out.
      # @return [Boolean] true if the user is authorized, false otherwise
      def authorized?
        true
      end
    end
  end
end
