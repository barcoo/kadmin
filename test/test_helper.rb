# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
$VERBOSE = false

# SimpleCov setup
require 'simplecov'
require 'simplecov-cobertura'
require 'simplecov-formatter-shield'
SimpleCov::Formatter::ShieldFormatter.filename = 'postman-web-shield.png'.freeze
SimpleCov.formatters = [SimpleCov::Formatter::CoberturaFormatter, SimpleCov::Formatter::ShieldFormatter]
SimpleCov.start

# Rails setup
require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'

# Setup Minitest
require 'minitest/reporters'
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Minitest::Reporters.use!([Minitest::Reporters::ProgressReporter.new, Minitest::Reporters::JUnitReporter.new], ENV,
  Minitest.backtrace_filter)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# AWS SDK
AWS.config(access_key_id: 'fake', secret_access_key: 'fake', region: 'eu-west-1')
AWS.stub!

# Setup Flexmock
require 'flexmock/minitest'

# Load postman
require 'postman'

# Set sane defaults for all TestCases
module ActiveSupport
  class TestCase
    self.use_transactional_fixtures = true

    def setup
      # Need to explicitly mount engine routes, otherwise the test cannot find them. Retarded, right?
      if defined?(@routes) && !@routes.nil?
        @routes = Postman::Web::Engine.routes
      end
    end
  end
end
