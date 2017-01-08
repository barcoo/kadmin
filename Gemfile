source 'https://rubygems.org'

# Declare your gem's dependencies in kadmin.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development, :profile do
  gem 'flamegraph', platforms: [:mri]
  gem 'memory_profiler', platforms: [:mri]
  gem 'rack-mini-profiler', platforms: [:mri]
  gem 'stackprof', platforms: [:mri] # ruby 2.1+ only
end

group :development do
  gem 'better_errors' # generate an error in dev, you'll see
  gem 'binding_of_caller' # for the above to get a console
  gem 'puma' # development webserver
  gem 'yard' # documentation generator, run rake yard
end

group :development, :test do
  gem 'byebug' # debugger
  gem 'pry-byebug' # pry integration for byebug
  gem 'pry-rails' # pry integration for rails
  gem 'pry-stack_explorer' # stack exploration
  gem 'sqlite3' # test database
end

group :test do
  gem 'flexmock', '~> 2.1.0', require: false
  gem 'minitest-reporters', '~> 1.1.9', require: false
  gem 'rails-controller-testing' # allows using assigns, assert_template
  gem 'simplecov', '~> 0.11.2', require: false
  gem 'simplecov-cobertura', '~> 1.1.0', require: false
  gem 'simplecov-formatter-shield', '~> 0.0.3', require: false
end
