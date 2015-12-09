source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '4.2.1'

# Database
gem 'pg'

# Users
gem 'bcrypt'
gem 'devise'

# Utilities
gem 'enumerize'
gem 'geometry'

# Views
gem 'haml-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0' # Compress JavaScript
gem 'kaminari'  # Pagination

# Semantic UI
gem 'therubyracer'
gem 'less-rails-semantic_ui', '~> 2.0.7.0'
gem 'autoprefixer-rails', '~> 5.2.1.2'

gem 'paperclip' # File attachments

# API
gem 'jsonapi-resources' # JSON API standard
gem 'api-pagination'    # Paginates API in headers

# Server
gem 'puma'
gem 'foreman', require: false

group :development do
  gem 'spring'            # Keeps environment in background
  gem 'better_errors'     # Clearer error messages
  gem 'binding_of_caller' # REPL & more in error page
  gem 'byebug'            # Debugger
  gem 'web-console', '~> 2.0'
  gem 'guard', '>= 2.2.2',       require: false # Autorun tests
  gem 'guard-minitest',          require: false # MiniTest adapter
  # Watch Mac filesystem events
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end

group :test do
  gem 'minitest-rails'     # Test library
  gem 'minitest-rails-capybara' # Integration tests
  gem 'minitest-reporters' # For progress bar, etc.
  gem 'codeclimate-test-reporter', require: nil
  gem 'launchy'
  gem 'rake' # Specified for Travis CI
end


