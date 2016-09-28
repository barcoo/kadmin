module RailsAdmin
  module Auth
    class User
      attr_accessor :email

      def initialize(email)
        @email = email
      end

      def authorized?(_request)
        return true
      end
    end
  end
end
