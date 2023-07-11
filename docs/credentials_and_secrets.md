# Credentials and Local Secrets
Rails credentials allows you to securely store sensitive configuration information and credentials for your Rails application. This feature is particularly useful for storing things like API keys, database passwords, or any other confidential data that your application needs to access.

Local secrets (environment variables) are secrets that are environment-specific information unique to your local system or the cloud platform you use such as Heroku. We use these variables when every local system requires different credentials. They can also be used to quickly change certain settings that might change very often like disabling a certain feature temporarily. There is no need to update any code and re-deploy the app in this case.

## Credentials
We use the default rails credentials file to store application credentials that can be accessed only by the app with the requirement of having a `master.key` file. This file will reside only on your local and your cloud platform as a config variable named `RAILS_MASTER_KEY`. The `master.key` file should not be pushed to github for security purposes.

### Viewing the credentials file
To view the application credentials using VS code, run `EDITOR='code --wait' rails credentials:edit` in your terminal. Replace `code` in the above command with the command of your specific editor if you're using another IDE.

### Credentials file setup
The credentials file will look like so. Credentials have different sections for each environment. Environments can also inherit from the **default** credentials. For example, **development** specific credentials will be nested under the `development:` section.

```
secret_key_base: xxx
default: &default
  global:
    key: 1234

test:
  <<: *default

development:
  <<: *default
  
  test:
  	key: abcdefg

staging:
  <<: *default

production:
  <<: *default

  postmark_api_token: XXX

  aws:
    access_key_id: XXX
    secret_access_key: XXX
    region: eu-west-2
    bucket: rapid_rails_production

  forest_admin:
    env_secret: XXX
    auth_secret: XXX
```    
- To read the value specific key within the app, run a command like so:
`Rails.application.credentials.dig(Rails.env.to_sym, :test, :key)`
The first param is the rails environment as a symbol. The params are the nested keys for the credentials in the order of nesting. The above command in a **development** environment would return **abcdefg** from the sample credentials file above. You may replace `Rails.env.to_sym` with the specific environment like `:production` to access only production credentials ifs required.

- Running`Rails.application.credentials.dig(Rails.env.to_sym, :global, :key)` in any environment will return **1234** as all the environments inherit the **default** credentials.

## Local Secrets
### Local Secrets setup on local system
We use [dotenv-rails](https://github.com/bkeepers/dotenv) to store local secrets on your local system.

1. Duplicate the `.env.template` file and set the filename as `.env`.
2. You can store your local secrets here like `HOST=localhost:3000`.
3. To access it anywhere in the application, use the `ENV` object on the variable like `ENV['HOST']`.

### Local Secrets setup on cloud platform
1. On your cloud platform, set the same value for `HOST` in your **config variables** settings.
2. The value of these variable can be quickly changes in the settings without re-deploying the app.
