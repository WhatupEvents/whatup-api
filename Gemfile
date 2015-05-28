source 'http://rubygems.org'

gem 'rails', '4.1.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sshkit', '1.3.0'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.3'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  # gem 'therubyracer', '0.10.1', platforms: :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'

gem 'rails-api', '~> 0.2.1'
gem 'active_model_serializers'
gem 'gcm'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-rails', '~> 1.1.0'
gem 'capistrano-unicorn-nginx', '~> 3.2.0'
gem 'capistrano-safe-deploy-to', '~> 1.1.1'
gem 'capistrano-bundler', '~> 1.1.2'

gem "capistrano-resque", "~> 0.2.2", require: false
gem 'resque'
gem 'resque-web', require: 'resque_web'

# Oauth api authentication
gem 'doorkeeper', '~> 1.4.0'

# To use debugger
gem 'pry-byebug'
gem 'pry-rails'
gem 'pry-stack_explorer'
gem 'foreman'

group :development, :staging do
  gem 'faker', '~> 1.4.3'
end
