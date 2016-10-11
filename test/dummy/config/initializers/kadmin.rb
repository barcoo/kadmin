module Dummy
  class User < Kadmin::Auth::User
    def authorized?(_request)
      return true
    end
  end

  class UserStore < Kadmin::Auth::UserStore
    def get(email)
      set(email, Dummy::User.new(email)) unless exists?(email)
      return @store[email.downcase]
    end
  end
end

Kadmin.config.logger = Rails.logger
Kadmin.config.mount_path = '/admin'

Kadmin::Auth.config.user_class = Dummy::User
Kadmin::Auth.config.user_store_class = Dummy::UserStore

Kadmin::Auth.config.enable!

Kadmin.config.navbar_links << { title: 'Test', path: '/admin/test' }
