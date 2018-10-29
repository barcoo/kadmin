module Kadmin
  module Auth
    class User
      attr_accessor :email, :accept, :organization

      def initialize(email, options = {})
        @email = email
        @admin = options[:admin]
        @organization = options[:organization]
        @accept = options[:accept]
      end

      def organization=(organization)
        @organization = organization if self.admin?
      end

      def authorized?(_request)
        return true
      end

      def admin?
        return @admin
      end
    end
  end
end
