module RailsAdmin
  class OmniauthController < ActionController::Base
    layout 'rails_admin/application'

    # GET /auth/login
    def login
      render 'rails_admin/omniauth/login'
    end

    # GET /auth/logout
    # DELETE /auth/logout
    def logout
      session.delete('rails_admin.user')
      redirect_to action: :login
    end

    # GET /auth/:provider/callback
    def save
      auth_hash = request.env['omniauth.auth']

      if auth_hash.blank?
        RailsAdmin.logger.error('No authorization hash provided')
        flash.alert = I18n.t('rails_admin.authorization.error')
        redirect_to action: :login
        return
      end

      email = auth_hash.dig('info', 'email')
      if authorized?(email)
        session['rails_admin.user'] = email
        redirect_url = request.env['omniauth.origin']
        redirect_url = RailsAdmin.config.fallback_redirect_url unless valid_redirect_url?(redirect_url)
      else
        flash.alert = I18n.t('rails_admin.authorization.unauthorized')
        redirect_url action: :login
      end

      redirect_to redirect_url
    end

    def valid_redirect_url?(url)
      valid = false

      unless url.blank?
        paths = [url_for(action: :login), url_for(action: :logout)]
        valid = paths.none? { |invalid| url == invalid }
      end

      return valid
    end
    protected :valid_redirect_url?

    def authorized?(_email)
      true
    end
    protected :authorized?
  end
end
