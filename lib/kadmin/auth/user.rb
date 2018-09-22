module Kadmin
  module Auth
    class User
      attr_accessor :email, :accept, :organization

      def initialize(email, options = {})
        @email = email
        @organization = 'default_organization'
      end

      def authorized?(_request)
        return true
      end

      def admin?
        return true
      end

    end
  end
end
