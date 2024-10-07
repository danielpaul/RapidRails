# File is prefixed with 0_ so that it loads first

# Load the YAML file based on the current environment
# This is for only ENABLE_FILE_UPLOAD constant since we need to 
# read that from the Gemfile also for installing gems.
global_variables = YAML.load_file(
  File.expand_path('../feature_flags.yml', __dir__), aliases: true
)[ENV['RAILS_ENV'] || 'development']

global_variables.each do |key, value|
  global_variable_name = key.upcase.to_sym
  Object.const_set(global_variable_name, value.freeze)
end

# Keep all constants and feature flags here so we can find them
# easily with case sensitive search in a code editor.

APP_NAME = "Rapid Rails".freeze

APPLE_TOUCH_ICON_PATH = "/apple-touch-icon.png".freeze
BROWSER_THEME_COLOR = "#000000".freeze

COMPANY_NAME = "Daniel Paul".freeze
COMPANY_LOCATION = "London, UK".freeze

HOST = ENV.fetch("HOST") { "localhost:3000" }.freeze

if Rails.env.production?
  BASE_URL = "https://#{HOST}".freeze
else
  BASE_URL = "http://#{HOST}".freeze
end

DEFAULT_FROM_EMAIL_ONLY = "team@#{HOST}".freeze
DEFAULT_FROM_EMAIL = "#{APP_NAME} <#{DEFAULT_FROM_EMAIL_ONLY}>".freeze

# Email Colors
EMAIL_LIGHT_BACKGROUND_COLOR = "#f5f5f7".freeze
EMAIL_LIGHT_CARD_BACKGROUND_COLOR = "#FFFFFF".freeze
EMAIL_LIGHT_TEXT_COLOR = "#51545E".freeze

EMAIL_DARK_BACKGROUND_COLOR = "#000000".freeze
EMAIL_DARK_CARD_BACKGROUND_COLOR = "#1c1c1e".freeze
EMAIL_DARK_TEXT_COLOR = "#FFF".freeze

EMAIL_PRIMARY_BUTTON_COLOR = "#0077ed".freeze
EMAIL_PRIMARY_BUTTON_TEXT_COLOR = "#FFF".freeze

ENABLE_SENTRY = Rails.env.production? || Rails.env.staging?
SENTRY_DSN_RAILS = "XXX".freeze
SENTRY_DSN_JS = "XXX".freeze

ENABLE_API = false
ENABLE_BLOG = true
ENABLE_ONBOARDING = true
ENABLE_GOOGLE_OAUTH = true

ANONYMIZE_USER_DATA_AFTER_DAYS = 7

if Rails.env.production?
  SITEMAP_HOST = "https://" +
    Rails.application.credentials.dig(Rails.env.to_sym, :aws, :bucket) +
    ".s3." +
    Rails.application.credentials.dig(Rails.env.to_sym, :aws, :region) +
    ".amazonaws.com"
end

# Active Storage
# Other constants set in feature_flags.yml
ENABLE_USER_AVATAR_UPLOAD = ENABLE_FILE_UPLOAD