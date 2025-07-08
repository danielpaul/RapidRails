source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3.0"

gem "rails", "~> 8.0.2"

# Asset pipeline library for Rails
gem "propshaft"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails", ">= 4.0.0.rc"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Front-end Things
gem "hamlit-rails"
gem "heroicon"
gem "high_voltage"
gem "meta-tags"
gem "pagy"
gem "phlex-rails"
gem "redcarpet"
gem "sitemap_generator"

# Authentication & Authorization
gem "devise"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "pundit"

# CMS
gem "contentful"
gem "rich_text_renderer"

# Backend Things
gem "discard"
gem "hashid-rails"
gem "paper_trail"
gem "rack-canonical-host"

# API
gem "blueprinter"
gem "jwt"

# Email Delivery
gem "postmark-rails"
gem "premailer-rails"

# Background Jobs
gem "sidekiq"

# Error Tracking & Performance
gem "sentry-rails"
gem "sentry-ruby"
gem "sentry-sidekiq"

# File Uploads
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# with Cloudflare R2 we still use AWS S3 compatible storage & SDK
# !!! Comment in the gems to ENABLE_FILE_UPLOAD
# gem "active_storage_validations"
# Use S3 SDK for Cloudflare R2 buckets
gem "aws-sdk-s3", ">= 1.185"
# gem "image_processing"

# Admin Panel
gem "activeadmin", "4.0.0.beta15"
gem "activeadmin_assets"

group :development, :test do
  gem "dotenv-rails"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Performance
  # gem "bullet"

  # Rspec
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers"

  # Security & Code Quality
  gem "brakeman"
  gem "standardrb"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"

  # Front-end Things
  gem "html2haml"
  gem "letter_opener"
  gem "hotwire-spark"

  gem "better_errors"
  gem "binding_of_caller"

  gem "annotaterb"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
