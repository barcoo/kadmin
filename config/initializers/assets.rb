# frozen_string_literal: true

%w[app vendor].each do |folder|
  path = Kadmin::Engine.root.join(folder, 'assets', '**', '*')
  Rails.application.config.assets.paths.concat(Dir.glob(path).select { |p| File.directory?(p) })
  Rails.application.config.assets.precompile.concat(Dir.glob(path).select { |p| File.file?(p) })
end
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
