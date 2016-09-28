module RailsAdmin
  class AuthController < ActionController::Base
    layout 'rails_admin/application'

    # @!group Endpoints
    # GET /auth/login
    def login
      render 'rails_admin/auth/login'
    end

    # GET /auth/logout
    # DELETE /auth/logout
    def logout
      session.delete('rails_admin.user')
      redirect_to action: :login
    end

    # GET /auth/:provider/callback
    # POST /auth/:provider/callback
    def save
      auth_hash = request.env['omniauth.auth']

      if auth_hash.blank?
        RailsAdmin.logger.error('No authorization hash provided')
        flash.alert = I18n.t('rails_admin.auth.error')
        redirect_to action: :login
        return
      end

      email = auth_hash.dig('info', 'email')
      if RailsAdmin::Auth.users.exists?(email)
        session['rails_admin.user'] = email
        redirect_url = request.env['omniauth.origin']
        redirect_url = RailsAdmin.config.mount_path unless valid_redirect_url?(redirect_url)
      else
        flash.alert = I18n.t('rails_admin.auth.unauthorized')
        redirect_url action: :login
      end

      redirect_to redirect_url
    end

    # GET /auth/failure
    def failure
      flash.alert = params[:message]
      redirect_to action: :login
    end

    # @!endgroup

    # @!group Helpers

    def valid_redirect_url?(url)
      valid = false

      unless url.blank?
        paths = [url_for(action: :login), url_for(action: :logout)]
        valid = paths.none? { |invalid| url == invalid }
      end

      return valid
    end
    protected :valid_redirect_url?

    def omniauth_provider_link
      base = "#{RailsAdmin.config.mount_path}/auth/#{RailsAdmin::Auth.omniauth_provider}"
      origin = params[:origin]

      origin = request.referer if origin.blank?
      origin = RailsAdmin.config.mount_path if origin.blank?

      return "#{base}?origin=#{CGI.escape(origin)}"
    end
    helper_method :omniauth_provider_link

    # @!endgroup
  end
end
