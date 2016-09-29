module RailsAdmin
  class DashController < RailsAdmin::ApplicationController
    # @!group Endpoints

    # GET /
    def index
    end

    # @!endgroup

    # @!group Helpers

    def set_navbar_links
      @layout_navbar_links = RailsAdmin.config.navbar_links
    end

    # @!endgroup
  end
end
