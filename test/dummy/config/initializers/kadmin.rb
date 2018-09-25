module Dummy
  class User < Kadmin::Auth::User
    def authorized?(_request)
      return true
    end
  end
end

Kadmin.config.logger = Rails.logger
Kadmin.config.mount_path = '/admin'

Kadmin::Auth.config.user_class = Dummy::User
Kadmin::Auth.config.user_store_class = Kadmin::Auth::UserStore

Kadmin::Auth.config.enable!

# seeding
Kadmin::Organization.find_or_create_by(name: 'offerista') # default organization needed in ApplicationController

Kadmin.config.handle_errors = !Rails.env.test? # rubocop: disable Barcoo/AvoidRailsEnv

Kadmin.config.add_navbar_items(
  Kadmin::Navbar::Section.new(
    id: Admin::PeopleController,
    text: 'People',
    links: [
      Kadmin::Navbar::Link.new(text: 'People list', path: ->(router) { router.admin_people_path }),
      Kadmin::Navbar::Link.new(text: 'Register new person', path: ->(router) { router.new_admin_person_path })
    ]
  ),
  Kadmin::Navbar::Section.new(
    id: Admin::GroupsController,
    text: 'Groups',
    links: [
      Kadmin::Navbar::Link.new(text: 'Groups list', path: ->(router) { router.admin_groups_path }),
      Kadmin::Navbar::Link.new(text: 'Add group', path: ->(router) { router.new_admin_group_path })
    ]
  )
)
