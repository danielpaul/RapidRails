# Credentials and Local Secrets

We use [Rails credentials](https://edgeguides.rubyonrails.org/security.html#environmental-security) for storing confidential data like API keys, database passwords..etc. It is used when the keys are shared by all the devs and we want it to exist in our codebase in version control.

Local secrets ([environment variables](https://guides.rubyonrails.org/v5.1/configuring.html#rails-environment-settings)) are used when devs might have different keys for their local setup or when there are multiple servers in different environments on the cloud platform(like Heroku).

## Credentials

- If `bin/setup` was run previously, a `master.key` should already exist and you can skip the next steps.
- If your admin has already setup the key, create a `master.key` file in the config folder and paste the key in the file without any line breaks.
- If both the above steps don't apply and a new key needs to be generated, run `EDITOR='echo' bin/rails credentials:edit` to create a new one.

### Viewing the credentials file

To view the application credentials using VS code, run `EDITOR='code --wait' rails credentials:edit` in your terminal. Replace `code` in the above command with the command of your specific editor if you're using another IDE.

### Credentials file setup

We use a single credentials file for all environments which is located at [config/credentials.yml.enc](../config/credentials.yml.enc).
For more details on Rails credentials and how to access or write to the file, refer to this [documentation](https://edgeguides.rubyonrails.org/security.html#environmental-security)

## Local Secrets

### Local Secrets setup on local system

We use [dotenv-rails](https://github.com/bkeepers/dotenv) to store local secrets on your local system.

1. Duplicate the `.env.template` file and set the filename as `.env`. You can skip this step if you've run the `bin/setup` command previously.
2. You can store your local secrets here like `HOST=localhost:3000`.
3. To access it anywhere in the application, use the `ENV` object on the variable like `ENV['HOST']`.

### Local Secrets setup on cloud platform

1. On your cloud platform, set the same value for `HOST` in your **config variables** settings.
2. The value of these variable can be quickly changes in the settings without re-deploying the app.
