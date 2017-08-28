# frozen_string_literal: true

class AuthorizedController < ApplicationController
  include Kadmin::Concerns::AuthorizedUser

  before_action :authorize

  def index; end
end
