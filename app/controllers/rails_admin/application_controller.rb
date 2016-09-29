module RailsAdmin
  class ApplicationController < ActionController::Base
    layout 'rails_admin/application'

    helper RailsAdmin::ApplicationHelper
    helper RailsAdmin::BootstrapHelper
    helper RailsAdmin::NavigationHelper
    helper RailsAdmin::PaginationHelper

    include RailsAdmin::Concerns::CurrentUser

    rescue_from RailsAdmin::Auth::UnauthorizedError, with: :handle_error
    rescue_from StandardError, with: :handle_error unless defined?(BetterErrors)
    def handle_error(error)
      locals = {
        title: error.try(:title) || error.class.name,
        message: error.message
      }
      render 'rails_admin/error', status: :internal_server_error, locals: locals
    end
  end
end
