# frozen_string_literal: true

require 'test_helper'

module Kadmin
  class AuthControllerTest < ActionController::TestCase
    def setup
      super
      Kadmin::Organization.find_or_create_by(name: 'offerista') # make sure default org exists
      @profital_org = Kadmin::Organization.find_or_create_by(name: 'profital')
    end

    def test_login
      get :login
      assert_response :ok
      assert_template 'kadmin/auth/login'

      fallback_origin = Kadmin.config.mount_path
      provider_path = "#{auth_path}/#{Kadmin::Auth.omniauth_provider}"
      provider_link = css_select('.content div > p > a').attr('href').value
      assert_equal "#{provider_path}?origin=#{CGI.escape(fallback_origin)}", provider_link

      # fake already logged in
      session[Kadmin::AuthController::SESSION_KEY] = 'admin@admin.com'
      get :login
      assert_redirected_to dash_path
    end

    def test_logout
      session[Kadmin::AuthController::SESSION_KEY] = 'admin@admin.com'
      get :logout
      assert_nil session[Kadmin::AuthController::SESSION_KEY]
      assert_redirected_to auth_login_path
    end

    def test_save
      post :save, params: { provider: Kadmin::Auth.omniauth_provider }
      assert_redirected_to auth_login_path
      assert_not_nil flash.alert # it doesn't matter too much what we wrote, just that we do notify the user

      nonexistent = 'does not exist'
      existent = 'does exist'
      flexmock(Kadmin::Auth.users).should_receive(:exists?).with(nonexistent).and_return(false)
      flexmock(Kadmin::Auth.users).should_receive(:exists?).with(existent).and_return(true)

      @request.env['omniauth.auth'] = { 'info' => { 'email' => nonexistent } }
      post :save, params: { provider: Kadmin::Auth.omniauth_provider }
      assert_redirected_to auth_login_path
      assert_not_nil flash.alert

      @request.env['omniauth.origin'] = dash_path
      @request.env['omniauth.auth'] = { 'info' => { 'email' => existent } }
      post :save, params: { provider: Kadmin::Auth.omniauth_provider }
      assert_redirected_to dash_path
      assert_equal existent, session[Kadmin::AuthController::SESSION_KEY]
    end

    def test_failure
      @request.env['omniauth.origin'] = 'origin'
      get :failure, params: { message: 'failed' }
      assert_redirected_to auth_login_path(origin: 'origin')
      assert_equal 'failed', flash.alert
    end

    def test_change_organization
      session[Kadmin::AuthController::SESSION_KEY] = 'admin@admin.com'
      post :change_organization, params: { organization_id: @profital_org.id }

      assert_redirected_to dash_path
      assert_equal @profital_org.name, session[Kadmin::AuthController::SESSION_ORG_OVERWRITE_KEY]
    end
  end
end
