source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
# datetime picker for active admin
gem 'active_admin_datetimepicker'
# Select2 for better select
gem "select2-rails"
# Administration Gem
gem 'activeadmin'
# Plus integrations with:
gem 'draper'
gem 'pundit'
# Active admin theme
gem 'arctic_admin'
# renaming project
gem "rename" 
# API Authorization
gem 'bcrypt', '~> 3.1.7'
# jwt for api token encryption
gem 'jwt'
# cors for api
gem 'rack-cors'
# image and file storage for aws
gem 'aws-sdk-s3', require: false
# pry for easier debugging
gem 'pry', '~> 0.12.2'
# Use awesome print for formating data in rails console
gem 'awesome_print', require: 'ap'
# Required library for devise
gem 'omniauth', '>= 1.0.0'
# Authentication gem for rails
gem 'devise'
# date grouping for dashboard
gem 'groupdate', '~> 2.5', '>= 2.5.2'
# cancancan for user authorization
gem 'cancancan'
# pagination
gem 'kaminari'
# to process excel and csv files
gem 'roo'
# create dummy data
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
# simple form for ready to used styled inputs
gem 'simple_form'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
