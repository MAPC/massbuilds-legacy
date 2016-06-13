ENV['RAILS_ENV'] = 'test'
ENV['GOOGLE_API_KEY'] = 'loLOLol'
ENV['AIRBRAKE_PROJECT_ID'] = '1234'
ENV['AIRBRAKE_PROJECT_KEY'] = 'test'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
%w( rails rails/capybara hell reporters focus ).each { |lib|
  require "minitest/#{lib}"
}
require 'minitest/benchmark' if ENV['BENCH']
require 'minitest/fail_fast' if ENV['FAST']

require 'webmock/minitest'
WebMock.disable_net_connect! allow: %w{ codeclimate.com }

# Require entire support tree
Dir[File.expand_path('test/support/**/*')].each { |file| require file }

Minitest::Reporters.use!(
  # Progress bar
  Minitest::Reporters::ProgressReporter.new, ENV, Minitest.backtrace_filter
)

class ActionController::TestCase
  include Devise::TestHelpers
end
class Capybara::Rails::TestCase
  include SessionHelpers
end
class ActiveSupport::TestCase
  fixtures :all # Set up all fixtures for all tests in alpha order.
  # Add more helper methods to be used by all tests here...
end
