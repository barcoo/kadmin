module Kadmin
  class ApplicationController < ActionController::Base
    layout 'kadmin/application'

    helper Kadmin::ApplicationHelper
    helper Kadmin::BootstrapHelper
    helper Kadmin::AlertHelper
    helper Kadmin::NavigationHelper
    helper Kadmin::PaginationHelper

    include Kadmin::Concerns::AuthorizedUser

    before_action :authorize
    before_action :set_navbar_links
    before_action :set_default_format

    # @!group Error Handling

    unless defined?(BetterErrors)
      rescue_from StandardError, with: :handle_unexpected_error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :params_missing
    end

    def params_missing(error)
      handle_error(error, title: I18n.t('kadmin.errors.params_missing'), status: :bad_request)
    end

    def not_found(error)
      handle_error(error, title: I18n.t('kadmin.errors.not_found'), status: :not_found)
    end

    def handle_unexpected_error(error)
      Rails.logger.error(error)
      handle_error(error, title: I18n.t('kadmin.errors.unexpected'), message: I18n.t('kadmin.errors.unexpected_message'))
    end

    def handle_error(error, options = {})
      options = {
        title: error.try(:title) || error.class.name,
        message: error.message,
        status: :internal_server_error
      }.merge(options)
      render 'kadmin/error', status: options[:status], locals: options
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
