[![Ruby on Rails CI](https://github.com/danielpaul/rails-starter/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/danielpaul/rails-starter/actions/workflows/rubyonrails.yml)
[![CodeQL](https://github.com/danielpaul/rails-starter/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/danielpaul/rails-starter/actions/workflows/github-code-scanning/codeql)
[![DeepSource](https://app.deepsource.com/gh/danielpaul/rails-starter.svg/?label=active+issues&show_trend=true&token=EPgQdBy2pEYTcBb-PA1yZnFc)](https://app.deepsource.com/gh/danielpaul/rails-starter/?ref=repository-badge)

# Getting Started

- [] Rename database name in `config/database.yml`
- [] Rename application name in `config/application.rb`
- [] Refresh `master.key` and `credentials.yml.enc` with `rails credentials:edit`
- [] Update `config/initializers/constants.rb` with all the variables

## TODO

- front-end UI
  - typography [x]
  - colors [x]
  - buttons
  - forms
    - text input
    - text area
    - select
    - radio
    - checkbox
    - date picker
    - time picker
    - file upload
  - cards
  - modals - side modal turboframe and normal modal for content
  - alerts
  - dark mode
- dark mode selector
  - settings in user account for dark mode preference
- devise pages
- sign in with google -> verify email because of this
- user settings page UI
- admin panel for internal use - ForestAdmin?
- HTML email
- error tracking - Sentry
- email delivery - Postmark
- analytics - GA and Mixpanel for product based events
- SEO / meta tags for differnt cases including mobile ios tags
- privacy poicy and terms and condition from basecamp template - static page with markdown ?
- GDPR marketing opt-in and opt-out - settings on user model
- payment gateway and user accounts for sass - maybe as a seperate codebase that is built for sass
- user impersonation - from forest admin / consider papertrail
- staging env with mail catcher, etc.
- active storage for file uploads (profile picture first)
- sidekiq and background jobs
