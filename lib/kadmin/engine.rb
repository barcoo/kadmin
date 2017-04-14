# Rails dependencies
require 'sass-rails'

module Kadmin
  class Engine < ::Rails::Engine
    isolate_namespace Kadmin

    initializer 'kadmin.install', after: :finisher_hook do
      Kadmin.logger = Rails.logger
    end
  end
end
