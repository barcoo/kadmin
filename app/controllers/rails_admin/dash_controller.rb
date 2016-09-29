module RailsAdmin
  class DashController < ApplicationController
    helper ActionView::Helpers::OutputSafetyHelper

    # @!group Endpoints

    # GET /
    def index
      @layout_navbar_links = RailsAdmin.config.navbar_links
    end

    # @!endgroup
  end
end
