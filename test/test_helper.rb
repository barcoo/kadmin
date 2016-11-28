# frozen_string_literal: true
# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
$VERBOSE = false

# Rails setup
require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'

# Setup Minitest
require 'minitest/reporters'
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Minitest::Reporters.use!([Minitest::Reporters::ProgressReporter.new], ENV,
  Minitest.backtrace_filter)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Setup Flexmock
require 'flexmock/minitest'

# Setup OmniAuth
# To fail authentication in your test, add:
# OmniAuth.config.mock_auth[:developer] = :invalid_credentials
OmniAuth.config.test_mode = true

# Load Kadmin
require 'kadmin'
require 'kadmin/presenter/test_case'

# Set sane defaults for all TestCases
module ActiveSupport
  class TestCase
    self.use_transactional_fixtures = true

    def setup
      # Need to explicitly mount engine routes, otherwise the test cannot find them. Retarded, right?
      @routes = Kadmin::Engine.routes if defined?(@routes) && !@routes.nil?
      OmniAuth.config.add_mock(:developer, email: 'test@test.com')
    end

    def teardown
      travel_back
      OmniAuth.config.mock_auth[:developer] = nil
    end
  end
end
