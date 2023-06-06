# File is prefixed with 0_ so that it loads first

APP_NAME = "Example App"

DEFAULT_FROM_EMAIL_ONLY = "team@example.com"
DEFAULT_FROM_EMAIL = "#{APP_NAME} <#{DEFAULT_FROM_EMAIL_ONLY}>"

SENTRY_DSN_RAILS = 'XXX'
SENTRY_DSN_JS = 'XXX'

ENABLE_SENTRY = false