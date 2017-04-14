# frozen_string_literal: true

%w(app vendor).each do |folder|
  path = Kadmin::Engine.root.join(folder, 'assets', '**', '*')
  Rails.application.config.assets.paths.concat(Dir.glob(path).select { |path| File.directory?(path) })
  Rails.application.config.assets.precompile.concat(Dir.glob(path).select { |path| File.file?(path) })
end
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
