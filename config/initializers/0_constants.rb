# File is prefixed with 0_ so that it loads first

APP_NAME = "Rails Starter".freeze

DEFAULT_FROM_EMAIL_ONLY = "team@example.com".freeze
DEFAULT_FROM_EMAIL = "#{APP_NAME} <#{DEFAULT_FROM_EMAIL_ONLY}>".freeze

ENABLE_SENTRY = Rails.env.production? || Rails.env.staging?
SENTRY_DSN_RAILS = "XXX".freeze
SENTRY_DSN_JS = "XXX".freeze
