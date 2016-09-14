module RailsAdmin
  module Omniauth
    class User
      attr_accessor :email

      def initialize(email)
        @email = email
      end

      def to_h
        return { email: @email }
      end
    end
  end
end
