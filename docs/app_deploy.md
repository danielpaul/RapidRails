# App Deploy

## Deploy without heroku

Setup your `master.key` that you used for your rails credentials file as `RAILS_MASTER_KEY`, domain as `HOST`, `RAILS_ENV` as `production` and `JEMALLOC_ENABLED` as `true`.
Also setup any environment variables that need to be added to production after deploy depending on the environment of the server.
Setup **Sidekiq**, **Redis**, **Postgres** and a **Task Scheduler** as we will need them to run our application.

## Heroku Setup

### Automatic Deploy

Deploy with an **app.json** file that helps Heroku pre-configure the application. You can click the button below to deploy using our template.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://dashboard.heroku.com/new?template=https://github.com/danielpaul/RapidRails)

### Manual Deploy

Install [Heroku CLI](https://toolbelt.heroku.com/) and login to Heroku account (`heroku login`).

Create your heroku app and deploy your **master** branch. You may also use the CLI to deploy your app:

1. `heroku git:remote -a example-app` where **example-app** is the name of your app on heroku.
2. `git push heroku main`

Setup these addons:

- Heroku Postgres addon
- Redis addon
- Heroku Scheduler addon

Set these config variables:

- Set `RAILS_MASTER_KEY` config var to decrypt `credentials.yml.enc` file
- Set `HOST` config var to your domain
- Set `RAILS_ENV` config var to `production`
- Set `JEMALLOC_ENABLED` config var to `true`

Setup Buildpacks:

- `heroku buildpacks:set heroku/ruby -a <app_name>` (will take last priority)
- `heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt.git -a <app_name>`
- `heroku buildpacks:add --index 2 https://github.com/brandoncc/heroku-buildpack-vips -a <app_name>`
- `heroku buildpacks:add --index 3 https://github.com/gaffneyc/heroku-buildpack-jemalloc.git -a <app_name>`

## Rake tasks and migrations

Add these default take tasks to your scheduler on production.

- `rake active_storage:purge_unattached_blobs` to purge unattached file that are older than 2 days in active storage. - Run once a day.
- `rake anonymize:users` to anonymize users data. - Run once a day. Important to delete user's data in our database. Give's time for them to change their mind before we delete their data.
- `rake sitemap:refresh` to refresh sitemap. - Run once a day.

Run rails `db:migrate` on production after deploy to setup your database.
