module Kadmin
  module Auth
    class UserStore
      def initialize
        @store = {}
      end

      def get(email)
        return @store[email.to_s.downcase]
      end

      def set(email, user)
        @store[email.to_s.downcase] = user
      end

      def exists?(email)
        @store.key?(email.to_s.downcase)
      end
    end
  end
end
