[![Ruby on Rails CI](https://github.com/danielpaul/rails-starter/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/danielpaul/rails-starter/actions/workflows/rubyonrails.yml)
[![CodeQL](https://github.com/danielpaul/rails-starter/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/danielpaul/rails-starter/actions/workflows/github-code-scanning/codeql)
[![DeepSource](https://app.deepsource.com/gh/danielpaul/rails-starter.svg/?label=active+issues&show_trend=true&token=EPgQdBy2pEYTcBb-PA1yZnFc)](https://app.deepsource.com/gh/danielpaul/rails-starter/?ref=repository-badge)

# System Requirements

- Ruby 3.2.2
- Node.js v18
- Bundler - `gem install bundler`

Homebrew dependencies:

- Redis - For ActionCable, Sidekiq, caching, etc.
- PostgreSQL - For database
- Overmind - For running Procfile processes
- Libvips or ImageMagick - For ActiveStorage image processing

All Homebrew dependencies are listed in `Brewfile`, so you can install them all at once like this:

```bash
brew bundle install --no-upgrade
```

Then you can start the database servers:

```bash
brew services start postgresql
brew services start redis
```

# Rails Getting Started

- [ ] Update `config/initializers/0_constants.rb` with all the variables
- [ ] Rename database name in `config/database.yml`

- [ ] run `bin/setup` to setup

- [ ] Refresh `master.key` and `credentials.yml.enc` with `rails credentials:edit` - ensure to update the `secret_key_base` to encrypt with your own key. Copy over the `credentials.sample.yml` contents.
- [ ] Copy `.env.sample` to `.env` and update the variables

# Running the app for development

- `bin/dev` to run the app locally
- `localhost:3000` to view the app
- `localhost:3000/rails/mailers` to view mailers preview locally
- `localhost:3000/letter_opener` to view emails sent locally
- `localhost:3000/sidekiq` to view sidekiq dashboard

# Gems Documentations

HTML templating & components:

- [HAML](https://haml.info/) - for HTML templating
- [Phlex](https://www.phlex.fun) - for Ruby components architecture

Backend:

- [Pagy](https://ddnexus.github.io/pagy/) - for pagination
- [Devise](https://github.com/heartcombo/devise) - for authentication
- [Pundit](https://github.com/varvet/pundit) - for authorization
- [PaperTrail](https://github.com/paper-trail-gem/paper_trail) - for versioning
- [ActiveStorage](https://edgeguides.rubyonrails.org/active_storage_overview.html) - for file uploads
- [Blueprinter](https://github.com/procore/blueprinter) - for JSON API serialization
- [Sidekiq](https://github.com/sidekiq/sidekiq) - for background jobs queue

Frontend:

- [Importmap Rails](https://github.com/rails/importmap-rails) - for JS modules
- [Tailwind CSS](https://tailwindcss.com/docs) - for CSS framework
- [Alpine JS](https://alpinejs.dev/) - for JS framework for inline JS animation & toggles, etc.
- [Stimulus JS](https://stimulus.hotwire.dev/handbook/introduction) - for JS framework
- [Hotwire](https://hotwire.dev/) - for Turbo and Stimulus JS

Testing:

- [Rspec](https://rspec.info/) - for testing
- [FactoryBot](https://github.com/thoughtbot/factory_bot) - for factories
- [Faker](https://github.com/faker-ruby/faker) - for fake data
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) - for testing matchers quickly

# External Services

- [Google OAuth2](https://code.google.com/apis/console/) - connecting with Google. Update Authorized redirect URIs and update credentials in our app. Set callback URL to `http://localhost:3000/users/auth/google_oauth2/callback` for development & similar for production with your domain.
- [Sentry](https://sentry.io/welcome/) - for error tracking. Setup two projects and update credentials - for Rails & JS frontend.
- [Postmark](https://postmarkapp.com/) - for transactional emails. Verify domain for sending emails.
- [Forest Admin](https://www.forestadmin.com/) - for admin panel.
- [AWS S3](https://aws.amazon.com/s3/) - for file uploads. Setup a S3 bucket and update credentials.
- [Contentful](https://www.contentful.com/) - for CMS. Update credentials. And import the BlogPost content model. Instructions below on conteful. 

# Things to Update

Checklist for things to update before you launch your app:

- [ ] Update Privacy Policy and Terms and Conditions
- [ ] Update `AnonymizationService` to anonymize user data and relating records where personal information is stored when user requests to delete their account. This is important to comply with GDPR & other regulations. User data is scrambled but the record is kept for audit trail. Alternatively just delete the record if you want to completely get rid of the data immediately. Update the destroy method on RegistrationsController.


# Contenful
We use Contentful (free plan) to manage blog posts. You can use Contentful for other content types as well and the structure is setup with webhooks and caching. Everything ready to go. 

To get setup:
1. Setup a new Contentful space.
2. Install the [Contentful CLI](https://www.contentful.com/developers/docs/tutorials/cli/installation/).
3. Import our sample model structure to the space. `contentful space import --space-id <space_id> --content-file lib/templates/contentful.json`
4. Create a Contentful API Key & update our credentails file.
5. Add some blog posts in Contentful & enjoy!


# Deploying to Heroku

### Automatic Deploy

Deploy with an app.json file that helps Heroku pre-configure the application.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://dashboard.heroku.com/new?template=https://github.com/danielpaul/RapidRails)

### Manual Deploy

Install [Heroku CLI](https://toolbelt.heroku.com/) and login to Heroku account (`heroku login`).

The usual steps (create a Heorku app, deploy the code) plus the following:

Install addons:

- [ ] Heroku Postgres addon
- [ ] Redis addon
- [ ] Heroku Scheduler addon

Set config vars:

- [ ] Set `RAILS_MASTER_KEY` config var to decrypt `credentials.yml.enc` file
- [ ] Set `RAILS_ENV` config var to `production`
- [ ] Set `JEMALLOC_ENABLED` config var to `true`

Setup Buildpacks:

- [ ] `heroku buildpacks:set heroku/ruby -a <app_name>` (will take last priority)
- [ ] `heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt.git -a <app_name>`
- [ ] `heroku buildpacks:add --index 2 https://github.com/brandoncc/heroku-buildpack-vips -a <app_name>`
- [ ] `heroku buildpacks:add --index 3 https://github.com/gaffneyc/heroku-buildpack-jemalloc.git -a <app_name>`

### Post Deploy

Run migrations:

- [ ] `heroku run rake db:migrate`

Other setup:

- [ ] Contentful - setup webhook to production server for clearing cache. `https://<HOST>/contentful/webhook`
- [ ] Setup Rake tasks below on the scheduler addon

# Rake Tasks

- [ ] `rake active_storage:purge_unattached_blobs` to purge unattached file that are older than 2 days in active storage. - Run once a day.
- [ ] `rake anonymize:users` to anonymize users data. - Run once a day. Important to delete user's data in our database. Give's time for them to change their mind before we delete their data.

## TODO

- rename codebase and move repo to new name

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
  - modals - side modal turboframe and normal modal for content

- analytics - GA and Mixpanel for product based events
- SEO / meta tags for differnt cases including mobile ios tags
- sitemap
- privacy poicy and terms and condition from basecamp template - static page with markdown ?
- GDPR marketing opt-in and opt-out - settings on user model
- payment gateway and user accounts for sass - maybe as a seperate codebase that is built for sass
- user impersonation - from forest admin / consider papertrail
- update favicon and other apple icons
