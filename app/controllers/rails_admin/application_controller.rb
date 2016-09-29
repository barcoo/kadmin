module RailsAdmin
  class ApplicationController < ActionController::Base
    layout 'rails_admin/application'

    helper RailsAdmin::ApplicationHelper
    helper RailsAdmin::BootstrapHelper
    helper RailsAdmin::NavigationHelper
    helper RailsAdmin::PaginationHelper

    include RailsAdmin::Concerns::AuthorizedUser

    before_action :authorize
    before_action :set_navbar_links

    # @!group Error Handling

    rescue_from StandardError, with: :handle_error unless defined?(BetterErrors)
    def handle_error(error)
      locals = {
        title: error.try(:title) || error.class.name,
        message: error.message
      }
      render 'rails_admin/error', status: :internal_server_error, locals: locals
    end

    # @!endgroup

    # @!group Helpers

    # Overload in the sub-controllers to set up the links in the layout
    def set_navbar_links
    end

    # @!endgroup
  end
end
