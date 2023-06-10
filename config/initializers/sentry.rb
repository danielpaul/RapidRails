Sentry.init do |config|
  # DSN is safe to store here and be visible to the public
  # https://docs.sentry.io/product/sentry-basics/dsn-explainer/

  # enabled_environments
  # unset the SENTRY_DSN variable to disable Sentry
  config.dsn = ENABLE_SENTRY ? SENTRY_DSN_RAILS : nil

  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  # nil (default) or 0.0 means the tracing feature is disabled.
  # If production, 0.1, staging 100%
  config.traces_sample_rate = Rails.env.production? ? 0.1 : 1.0

  # When its value is false (default), sensitive information like
  # user ip, user cookie, request body, query string in the url
  # will not be sent to Sentry.
  config.send_default_pii = false

  # more config options:
  # https://docs.sentry.io/platforms/ruby/guides/rails/configuration/options/
end
