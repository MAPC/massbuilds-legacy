source 'https://rubygems.org'

ruby '2.3.1'

gem 'bundler', '1.11.2'

gem 'rails', '4.2.5.1'

# Database
gem 'pg'
gem 'periscope-activerecord' # Makes filtering simpler
gem 'seed-fu', '~> 2.3'      # Manages fixtures
gem 'enumerize' # Store options in a string field
gem 'activerecord-postgis-adapter'
gem 'rgeo'
gem 'rgeo-geojson'
gem 'pg_search'
# gem 'active_hash'
# gem 'paperclip' # File attachments

# Users
gem 'bcrypt'
gem 'devise'
gem 'authority'

# Utilities
gem 'mailgun_rails'
gem 'geometry' # Simple geometry constructor
gem 'wannabe_bool', '0.3.0' # Convert to boolean
gem 'stamp' # Easier timestamps
gem 'geocoder'

# Forms & Presenters
gem 'virtus'       # Form objects
gem 'burgundy'     # Tiny decorator/presenter library
gem 'escape_utils' # Speeds up uri_template
gem 'uri_template' # Rendering dynamic URLs

# Views
gem 'haml-rails'   # Use HAML views
gem 'sass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0' # Compress JavaScript
gem 'kaminari'      # Pagination
gem 'leaflet-rails' # Maps
gem 'wicked_pdf', '~> 1.0'    # PDF generation
gem 'wkhtmltopdf-binary-edge' # PDF generation binary
gem 'ember-cli-rails', git: 'https://github.com/allthesignals/ember-cli-rails'
gem 'meta-tags'    # SEO, Open Graph tags
gem 'high_voltage', '~> 3.0.0' # Static pages

# Semantic UI
gem 'therubyracer'
gem 'less-rails-semantic_ui', '~> 2.1'
gem 'autoprefixer-rails', '~> 5.2.1.2'

# API
gem 'jsonapi-resources' # JSON API standard
gem 'api-pagination'    # Paginates API in headers
gem 'versionist'

# Server
gem 'puma'
gem 'airbrake', '~> 5.2'              # Error reporting
gem 'rack-cors', require: 'rack/cors' # CORS Headers

group :development do
  gem 'foreman', require: false
  gem 'spring'            # Keeps environment in background
  gem 'better_errors'     # Clearer error messages
  gem 'binding_of_caller' # REPL & more in error page
  gem 'byebug'            # Debugger
  gem 'web-console', '~> 2.0'
  gem 'guard', '>= 2.2.2',       require: false # Autorun tests
  gem 'guard-minitest',          require: false # MiniTest adapter
  # Watch Mac filesystem events
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'brakeman', require: false # Assess security
  gem 'rubocop'

  gem 'faker', require: false  # Fake sample data
end

group :development, :test do
  gem 'bullet', '4.14.10' # SQL diagnostics
end

group :test do
  gem 'minitest-rails'     # Test library
  gem 'minitest-rails-capybara' # Integration tests
  gem 'minitest-reporters' # For progress bar, etc.
  gem 'minitest-fail-fast' # End testing on first failure
  gem 'minitest-focus'     # One test at a time
  gem 'codeclimate-test-reporter', require: nil
  gem 'launchy'
  gem 'rake' # Specified for Travis CI
  gem 'webmock' # Disable network connections
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
