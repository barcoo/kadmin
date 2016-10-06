module Dummy
  class User < Kadmin::Auth::User
    def initialize(email, resources: [])
      super(email)
      @resources = resources
    end

    def authorized?(_request)
      return true
    end
  end

  class UserStore < Kadmin::Auth::UserStore
    def initialize
      super

      set('admin@test.com', Dummy::User.new('admin@test.com', resources: [:posts]))
    end
  end
end

Kadmin.config.logger = Rails.logger
Kadmin.config.mount_path = '/kadmin'

Kadmin::Auth.config.user_class = Dummy::User
Kadmin::Auth.config.user_store_class = Dummy::UserStore

Kadmin::Auth.config.enable!

Kadmin.config.navbar_links << { title: 'Test', path: '/admin/test' }
