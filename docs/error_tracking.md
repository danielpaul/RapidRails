# Error Tracking Documentation

We use Sentry for real-time error tracking. It tracks errors both on Rails and JS as two separate projects one for backend and front-end.

## Rails Configuration Options

The Rails configuration for Sentry is initialized in the **config/initializers/sentry.rb** file. Here's a brief explanation of the configuration options:

- `config.dsn`: This is the Data Source Name (DSN) for Sentry. If `ENABLE_SENTRY` is **true**, it uses the constant `SENTRY_DSN_RAILS` which stores the client key from sentry for your Rails project. If **false**, it sets the DSN to nil, effectively disabling Sentry.

- `config.breadcrumbs_logger`: This is an array of loggers for breadcrumbs. It currently includes `active_support_logger` and `http_logger`.

- `config.traces_sample_rate`: This sets the rate at which traces are sampled for performance monitoring. If the environment is production, it captures 10% of transactions. Otherwise, it captures 100%.

- `config.send_default_pii`: This is a boolean value that determines whether sensitive information (like user IP, user cookie, request body, query string in the URL) is sent to Sentry. It is currently set to false.

For more configuration options, refer to the [official Sentry documentation](https://docs.sentry.io/platforms/ruby/guides/rails/configuration/options/``). 

## JS Configuration Options

The JavaScript configuration for Sentry is initialized at the bottom of the **views/layouts/components/_head.html.haml** file. Here's a brief explanation of the configuration options:

- dsn: This is the Data Source Name (DSN) for Sentry. It's set to the value of the constant `SENTRY_DSN_JS` which stores the client key from sentry for your JS project.

- environment: This is set to the current Rails environment.

- integrations: This is an array of integrations to be used with Sentry. Currently, it includes `Sentry.BrowserTracing()` for browser performance tracing.

- tracesSampleRate: This sets the rate at which traces are sampled for performance monitoring. It's currently set to 0.25, meaning 25% of transactions are captured.

For more configuration options, refer to the [official Sentry JavaScript documentation](https://docs.sentry.io/platforms/javascript/configuration/). 
