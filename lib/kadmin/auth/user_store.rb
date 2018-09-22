module Kadmin
  module Auth
    class UserStore
      def initialize
        @store = {}
        load_users!
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

      def load_users!
        file = Rails.root.join('config', 'admin_users.yml')
        if File.readable?(file)
          definitions = YAML.load_file(file.to_s)
          definitions.each do |definition|
            email = definition['email']
            options = {
              admin: definition.fetch('admin', false),
              accept: Array.wrap(definition.fetch('accept', [])).map(&:to_sym),
              organization: definition.fetch('organization', 'offerista')
            }

            set(email, Kadmin::Auth.config.user_class.new(email, **options))
          end
        end
      end
      private :load_users!
    end
  end
end
