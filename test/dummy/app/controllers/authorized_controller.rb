class AuthorizedController < ApplicationController
  include RailsAdmin::Concerns::AuthorizedUser

  before_action :authorize

  def index
  end
end
