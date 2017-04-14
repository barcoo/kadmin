$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'kadmin/version'

Gem::Specification.new do |s|
  s.name        = 'kadmin'
  s.version     = Kadmin::VERSION
  s.authors     = ['Nicolas Pepin-Perreault', 'Sergio Medina', 'Teymour Taghavi']
  s.email       = ['nicolas.pepin-perreault@offerista.com', 'sergio.medina@offerista.com', 'teymour.taghavi@offerista.com']
  s.homepage    = 'https://github.com/barcoo/kadmin'
  s.summary     = 'Collection of utility, configuration, etc., for admin areas'
  s.description = 'Collection of utility, configuration, etc., for admin areas in a Rails application. Provides a boostrap environment, standard layout, authentication, and more.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'test/factories/**/*', 'Rakefile', 'README.md']

  # Core
  s.add_dependency 'rails', '>= 4.2', '< 6'
  s.add_dependency 'i18n', '~> 0.7'

  # Front-end stuff
  s.add_dependency 'sass-rails', '~> 5.0' # to use Sass files
  s.add_dependency 'omniauth-google-oauth2', '~> 0.4' # for authentication
end
