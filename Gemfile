source 'https://rubygems.org'

# Declare your gem's dependencies in kadmin.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development, :profile do
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof' # ruby 2.1+ only
  gem 'memory_profiler'
end

group :development do
  gem 'better_errors' # generate an error in dev, you'll see
  gem 'binding_of_caller' # for the above to get a console
  gem 'quiet_assets' # no logs for assets in dev
  gem 'puma' # development webserver
  gem 'yard' # documentation generator, run rake yard
end

group :development, :test do
  gem 'sqlite3' # test database
  gem 'byebug' # debugger
  gem 'pry-byebug' # pry integration for byebug
  gem 'pry-rails' # pry integration for rails
  gem 'pry-stack_explorer' # stack exploration
end

group :test do
  gem 'minitest-reporters', '~> 1.1.9', require: false
  gem 'simplecov', '~> 0.11.2', require: false
  gem 'simplecov-cobertura', '~> 1.1.0', require: false
  gem 'simplecov-formatter-shield', '~> 0.0.3', require: false
  gem 'flexmock', '~> 2.1.0', require: false
end
