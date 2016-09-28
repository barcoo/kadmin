module RailsAdmin
  module Auth
    class UserStore
      def initialize
        @store = {}
      end

      def get(email)
        return @store[email.downcase]
      end

      def set(email, user)
        @store[email.downcase] = user
      end

      def exists?(email)
        @store.key?(email.downcase)
      end
    end
  end
end
