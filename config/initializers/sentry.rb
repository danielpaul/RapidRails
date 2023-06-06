Sentry.init do |config|
  # DSN is safe to store here and be visible to the public
  # https://docs.sentry.io/product/sentry-basics/dsn-explainer/
  config.dsn = SENTRY_DSN_RAILS

  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 0.25

  # Sentry set to work only in production environment
  config.enabled_environments = %w[production]
end
