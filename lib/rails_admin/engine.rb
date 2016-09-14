# Rails dependencies
require 'bootstrap-sass'
require 'sass-rails'
require 'jquery-rails'
require 'select2-rails'

module RailsAdmin
  class Engine < ::Rails::Engine
    isolate_namespace RailsAdmin

    initializer 'rails_admin.install', after: :finisher_hook do
      RailsAdmin.logger = Rails.logger
    end
  end
end
