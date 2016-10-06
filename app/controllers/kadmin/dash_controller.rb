module Kadmin
  class DashController < Kadmin::ApplicationController
    # @!group Endpoints

    # GET /
    def index
    end

    # @!endgroup

    # @!group Helpers

    def set_navbar_links
      @layout_navbar_links = Kadmin.config.navbar_links
    end

    # @!endgroup
  end
end
