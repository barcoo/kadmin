require 'English'

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('../test/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task default: :test

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb', 'app/**/*.rb', 'config/**/*.rb']
    t.options = ['--output-dir=./docs']
  end
rescue LoadError
  puts 'yard not present, disabling Rake task'
end
