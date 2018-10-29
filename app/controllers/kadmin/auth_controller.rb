module Kadmin
  class AuthController < Kadmin::ApplicationController
    SESSION_KEY = 'kadmin.user'.freeze

    # Don't try to authenticate user on the authentication controller...
    skip_before_action :authorize

    # @!group Endpoints
    # GET /auth/login
    def login
      if logged_in? && authorized?
        redirect_to dash_path
      else
        render 'kadmin/auth/login'
      end
    end

    # GET /auth/logout
    # DELETE /auth/logout
    def logout
      session.delete(SESSION_KEY)
      redirect_to auth_login_path
    end

    # GET /auth/:provider/callback
    # POST /auth/:provider/callback
    def save
      auth_hash = request.env['omniauth.auth']

      if auth_hash.blank?
        Kadmin.logger.error('No authorization hash provided')
        flash.alert = I18n.t('kadmin.auth.error')
        redirect_to auth_login_path(origin: request.env['omniauth.origin'])
        return
      end

      email = auth_hash.dig('info', 'email')
      if Kadmin::Auth.users.exists?(email)
        session[SESSION_KEY] = email
        redirect_url = request.env['omniauth.origin']
        redirect_url = Kadmin.config.mount_path unless valid_redirect_url?(redirect_url)
      else
        flash.alert = I18n.t('kadmin.auth.unauthorized_message')
        redirect_url = auth_login_path(origin: request.env['omniauth.origin'])
      end

      redirect_to redirect_url
    end

    # GET /auth/failure
    def failure
      flash.alert = params[:message]
      redirect_to auth_login_path(origin: request.env['omniauth.origin'])
    end

    def unauthorized
      render 'kadmin/error', format: ['html'], locals: {
        title: I18n.t('kadmin.auth.unauthorized'),
        message: I18n.t('kadmin.auth.unauthorized_message')
      }
    end

    # POST /change_organization
    def change_organization
      if authorized_user.admin?
        authorized_user.organization = Kadmin::Organization.find(params[:organization_id]).name
      end
      redirect_to :dash
    end

    # @!endgroup

    # @!group Helpers

    def valid_redirect_url?(url)
      valid = false

      if url.present?
        paths = [auth_login_path, auth_logout_path]
        valid = paths.none? { |invalid| url == invalid }
      end

      return valid
    end
    protected :valid_redirect_url?

    def omniauth_provider_link
      auth_prefix = auth_path
      provider_link = "#{auth_prefix}/#{Kadmin::Auth.omniauth_provider}"
      origin = params[:origin]

      # if the referer is a auth route, then we risk ending in an endless loop
      if origin.blank?
        referer = request.referer
        if referer.blank?
          origin = Kadmin.config.mount_path
        else
          uri = URI(referer)
          origin = referer unless uri&.path&.start_with?(auth_prefix)
        end
      end

      provider_link = "#{provider_link}?origin=#{CGI.escape(origin)}" if origin.present?
      return provider_link
    end
    helper_method :omniauth_provider_link

    # @!endgroup
  end
end
