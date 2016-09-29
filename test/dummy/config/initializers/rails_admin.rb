module Dummy
  class User < RailsAdmin::Auth::User
    def initialize(email, resources: [])
      super(email)
      @resources = resources
    end

    def authorized?(_request)
      return true
    end
  end

  class UserStore < RailsAdmin::Auth::UserStore
    def initialize
      super

      set('admin@test.com', Dummy::User.new('admin@test.com', resources: [:posts]))
    end
  end
end

RailsAdmin.config.logger = Rails.logger
RailsAdmin.config.mount_path = '/admin'

RailsAdmin::Auth.config.user_class = Dummy::User
RailsAdmin::Auth.config.user_store_class = Dummy::UserStore

RailsAdmin::Auth.enable!

RailsAdmin.config.navbar_links << RailsAdmin::Configuration::Link.new('Test', '/admin/test')
