# Heroku Database Backup

Let's take a look at how to set up scheduled database backups on Heroku.

## Set up a Backup Schedule

To set up a backup schedule run:

```
heroku pg:backups:schedule DATABASE_URL --at '03:00 Europe/London' --app example-app
```

This sets up an automatic backup every day at 03:00 London time. You can change this to any time you prefer.

For more information, see the [backup documentation](https://devcenter.heroku.com/articles/heroku-postgres-backups#scheduled-backups) from Heroku.
