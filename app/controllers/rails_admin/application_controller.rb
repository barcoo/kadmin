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
    before_action :set_default_format

    # @!group Error Handling

    unless defined?(BetterErrors)
      rescue_from StandardError, with: :handle_error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :params_missing
    end

    def params_missing(error)
      handle_error(error, title: I18n.t('rails_admin.errors.params_missing'), status: :bad_request)
    end

    def not_found(error)
      handle_error(error, title: I18n.t('rails_admin.errors.not_found'), status: :not_found)
    end

    def handle_error(error, options = {})
      options = {
        title: error.try(:title) || error.class.name,
        message: error.message,
        status: :internal_server_error
      }.merge(options)
      render 'rails_admin/error', status: options[:status], locals: options
    end

    # @!endgroup

    # @!group Helpers

    # Overload in the sub-controllers to set up the links in the layout
    def set_navbar_links
      @layout_navbar_links = []
    end
    protected :set_navbar_links

    def set_default_format
      params[:format] = 'html' if params[:format].blank?
    end
    protected :set_default_format

    # @!endgroup
  end
end
