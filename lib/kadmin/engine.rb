# Rails dependencies
require 'sass-rails'
require 'jquery-rails'

module Kadmin
  class Engine < ::Rails::Engine
    isolate_namespace Kadmin

    initializer 'kadmin.install', after: :finisher_hook do
      Kadmin.logger = Rails.logger
      Kadmin::Engine.load_assets(config, 'app/assets')
      Kadmin::Engine.load_assets(config, 'vendor/assets')
    end

    class << self
      def load_assets(config, root)
        folder = Kadmin::Engine.root.join(root).to_s
        config.assets.paths << Dir.glob(folder).select { |path| File.directory?(path) }
        config.assets.precompile << Dir.glob("#{folder}/**/*").select { |path| File.file?(path) }
      end
    end
  end
end
