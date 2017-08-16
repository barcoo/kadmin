class AuthorizedController < ApplicationController
  include Kadmin::Concerns::AuthorizedUser

  before_action :authorize

  def index; end
end
