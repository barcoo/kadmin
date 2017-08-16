# frozen_string_literal: true

require 'test_helper'

module Kadmin
  module Concerns
    # NOTE: Relies on the test dummy app's AuthorizedController, which does nothing
    # but include this concern.
    class AuthorizedUserTest < ActionController::TestCase
      tests AuthorizedController

      def setup
        super
        @routes = Rails.application.routes # reenable normal routes here
      end

      def test_authorize
        Kadmin::Auth.config.disable!
        get :index
        assert_template 'authorized/index'

        Kadmin::Auth.config.enable!
        get :index
        assert_redirected_to Kadmin::Engine.routes.url_helpers.auth_login_path(origin: authorized_path)

        session[Kadmin::AuthController::SESSION_KEY] = 'test'
        get :index
        assert_template 'authorized/index'

        flexmock(Kadmin::Auth::User).new_instances.should_receive(:authorized?).and_return(false)
        get :index
        assert_redirected_to Kadmin::Engine.routes.url_helpers.auth_unauthorized_path
      end

      # @!group Helpers

      def test_current_user
        session[Kadmin::AuthController::SESSION_KEY] = nil
        assert_nil @controller.current_user

        session[Kadmin::AuthController::SESSION_KEY] = 'test'
        assert_equal 'test', @controller.current_user
      end

      def test_authorized_user
        session[Kadmin::AuthController::SESSION_KEY] = 'test'
        assert @controller.authorized_user.is_a?(Kadmin::Auth::User)
        assert_equal 'test', @controller.authorized_user.email

        flexmock(Kadmin::Auth.users).should_receive(:get).with('test').and_return(nil)
        assert_nil @controller.authorized_user
      end

      def test_logged_in?
        assert !@controller.logged_in?

        session[Kadmin::AuthController::SESSION_KEY] = 'test'
        assert @controller.logged_in?
      end

      def test_authorized?
        session[Kadmin::AuthController::SESSION_KEY] = 'test'
        assert @controller.authorized?

        flexmock(Kadmin::Auth.users).should_receive(:get).with('test').and_return(nil)
        assert !@controller.authorized?
      end

      # @!endgroup
    end
  end
end
