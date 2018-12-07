# frozen_string_literal: true

module Kadmin
  class ApplicationController < ActionController::Base
    layout 'kadmin/application'

    helper Kadmin::ApplicationHelper
    helper Kadmin::BootstrapHelper
    helper Kadmin::AlertHelper

    include Kadmin::Concerns::AuthorizedUser

    before_action :authorize
    before_action :set_default_format
    before_action :organization

    # Each controller should specify which navbar section they
    # belong to, if any. By default, each controller is setup to
    # be its own section.
    class_attribute :navbar_section

    # @!group Error Handling

    if Kadmin.config.handle_errors
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
        status: :internal_server_error,
        error: error
      }.merge(options)
      render 'kadmin/error', status: options[:status], locals: options
    end

    # @!endgroup

    # returns organization_scoped_ar object(s) by id (or array of ids) or throw RecordNotFound in case
    # id(s) does not exist or is not visible in scope
    #
    # organization_scoped_ar is an ActiveRecord that has organization_scope(Organization) scope defined
    def scoped_find_by!(organization_scoped_ar, id)
      return organization_scoped_ar.organization_scope(@organization).find(id)
    end

    # returns all organization_scoped_ar object(s) that are of the user's organization. admin user gets all.
    # you can chain scopes, e.g. scoped_all(Segments.my_scope) is valid
    # organization_scoped_ar is an ActiveRecord that has organization_scope(Organization) scope defined
    def scoped_all(organization_scoped_ar)
      organization_scoped_ar.organization_scope(organization).all
    end

    def organization
      if authorized_user.present?
        if !@organization 
          if session[Kadmin::AuthController::SESSION_ORG_OVERWRITE_KEY] && authorized_user.admin?
            @organization = Kadmin::Organization.find_by!(name: session[AuthController::SESSION_ORG_OVERWRITE_KEY])
          else
            @organization = Kadmin::Organization.find_by!(name: authorized_user.organization)
          end
        end
      end
      return @organization
    rescue ActiveRecord::RecordNotFound
      render plain: "Forbidden - organization #{authorized_user.organization} not found in DB", status: :forbidden
    end

    # @!group Helpers

    protected

    def set_default_format
      params[:format] = 'html' if params[:format].blank?
    end

    # @!endgroup
  end
end
