# frozen_string_literal: true

require 'bundler/setup'
require 'database_cleaner'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../spec/dummy/config/environment'

ENV['GRAPHQL_RUBY_VERSION'] ||= '1_8'
ENV['JWT_SECRET_KEY'] ||= 'secret_test_key'

if ENV['CI']
  require 'simplecov'
  SimpleCov.add_filter('spec')
  require 'coveralls'
  Coveralls.wear!
end

require 'graphql-auth'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end