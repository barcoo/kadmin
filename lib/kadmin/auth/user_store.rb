module Kadmin
  module Auth
    class UserStore
      def initialize(path = nil)
        @store = {}

        path ||= Rails.root.join('config', 'admin_users.yml')
        if File.exist?(path) && File.readable?(path)
          definitions = YAML.load_file(path.to_s)
          create_organizations(definitions['organizations'])
          load_users(definitions['users'])
        else
          Rails.logger.warn("Can't read admin users auth file at #{path}. Auth might not work")
        end
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

      private

      def load_users(users)
        users.each do |user|
          email = user['email']
          options = {
            admin: user.fetch('admin', false),
            accept: Array.wrap(user.fetch('accept', [])).map(&:to_sym),
            organization: user.fetch('organization', 'offerista') # default organization, needs to exist in DB
          }

          set(email, Kadmin::Auth.config.user_class.new(email, **options))
        end
      end

      def create_organizations(organizations)
        organizations.each do |organization|
          Kadmin::Organization.find_or_create_by(name: organization)
        end
      end
    end
  end
end
