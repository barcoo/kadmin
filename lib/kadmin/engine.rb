# Rails dependencies
require 'sass-rails'

module Kadmin
  class Engine < ::Rails::Engine
    isolate_namespace Kadmin

    initializer 'kadmin.install' do
      Kadmin.logger = Rails.logger
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match(root.to_s)
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end
  end
end
