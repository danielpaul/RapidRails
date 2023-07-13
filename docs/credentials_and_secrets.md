# Credentials and Local Secrets

**Note:** If you have used the `bin/setup` script to setup your app, you don't need to manually create any of the files and do any setup. The details outline how the credentials are managed in the app.

RapidRails uses [Rails credentials file](https://edgeguides.rubyonrails.org/security.html#environmental-security) for storing confidential data like API keys, database passwords, etc. It is used when the **values are shared by all the devs** and we want it to exist in our codebase in version control.

Local secrets ([environment variables](https://guides.rubyonrails.org/v5.1/configuring.html#rails-environment-settings)) are used when devs might have different keys for their local setup or when there are multiple deployments of the app with different configuration.

## Rails Credentials File

We use a single credentials file for all environments [credentials.yml.enc](../config/credentials.yml.enc).
For more details on Rails credentials and how to access or write to the file, refer to this [documentation](https://edgeguides.rubyonrails.org/security.html#environmental-security).

- If setting up a new app, delete [credentials.yml.enc](../config/credentials.yml.enc) and run `EDITOR='echo' bin/rails credentials:edit` to create a new credentials file and `master.key`.
- If previously setup and your admin has the key, create a `master.key` file in the config folder and paste the key in the file without any line breaks.

### Viewing the credentials file

To view the application credentials using VS code, run `EDITOR='code --wait' rails credentials:edit` in your terminal. Replace `code` in the above command with the command of your specific editor if you're using another IDE.

## Local Secrets

### Local Secrets setup on local system

We use [dotenv-rails](https://github.com/bkeepers/dotenv) to store local secrets on your local system.

1. Duplicate the [.env.template](../.env.template) file and set the filename as `.env`. You can skip this step if you've run the `bin/setup` command previously.
2. You can store your local secrets here like `HOST=localhost:3000`.
3. To access it anywhere in the application, use the `ENV` object on the variable like `ENV['HOST']`.

### Local Secrets setup on cloud platform

1. On your cloud platform, set the same value for `HOST` in your config variables settings. On heroku it can be changed [like so](https://devcenter.heroku.com/articles/config-vars)
![](../docs/images/config_vars.png)
2. The value of these variable can be quickly changed without re-deploying the app.
