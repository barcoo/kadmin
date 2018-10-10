# Rails dependencies
require 'sass-rails'

module Kadmin
  class Engine < ::Rails::Engine
    isolate_namespace Kadmin

    # push engine factory paths always at the top of the path stack
    initializer 'kadmin.factories', after: 'factory_bot.set_factory_paths' do
      factory_paths = File.expand_path('../../../test/factories', __FILE__) # path relative to installation location
      FactoryBot.definition_file_paths.unshift(factory_paths) if defined?(FactoryBot)
    end

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
