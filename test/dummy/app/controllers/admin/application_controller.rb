module Admin
  class ApplicationController < Kadmin::ApplicationController
    def set_navbar_links
      super
      @layout_navbar_links += [
        { title: 'Persons', path: admin_persons_path },
        { title: 'Groups', path: admin_groups_path }
      ]
    end
  end
end
