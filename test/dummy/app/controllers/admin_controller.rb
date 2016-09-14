class AdminController < ApplicationController
  include RailsAdmin::Concerns::Authorization

  before_action :authorized?

  def index
    render plain: 'You are authorized'
  end

  def authorize
    username = current_user.split('@').first
    return username == 'admin'.freeze
  end
end
