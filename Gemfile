source 'https://rubygems.org'

# Declare your gem's dependencies in kadmin.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development do
  gem 'binding_of_caller' # for the above to get a console
  gem 'puma' # development webserver
  gem 'yard' # documentation generator, run rake yard
  gem 'mysql2' # test database
end

group :development, :debug do
  gem 'byebug' # debugger
  gem 'pry-byebug' # pry integration for byebug
  gem 'pry-rails' # pry integration for rails
  gem 'pry-stack_explorer' # stack exploration
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.0' # test database
end

group :test do
  gem 'factory_bot_rails'
  gem 'flexmock', '~> 2.1.0', require: 'flexmock/minitest'
  gem 'minitest-reporters', '~> 1.1.9'
  gem 'rails-controller-testing' # allows using assigns, assert_template
end

group :ci do
  gem 'simplecov', '~> 0.11.2'
  gem 'simplecov-cobertura', '~> 1.1.0'
  gem 'simplecov-formatter-shield', '~> 0.0.3'
end
