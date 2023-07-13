# Emails

## Local Development

We use the gem [Letter Opener Web](https://github.com/fgrehm/letter_opener_web) to deliver emails in development for testing purposes. It provides a web interface based on the original [Letter Opener](https://github.com/ryanb/letter_opener) gem. All delivered emails can be accessed at `localhost:3000/letter_opener`.

If you prefer the email to open a new browser tab on delivery, you can update the config to `config.action_mailer.delivery_method = :letter_opener` in the [development.rb](../config/environments/development.rb) file.

## Email Styles

We have a mailer layout that supports both **Dark Mode** and **Light Mode** settings in the email client or based on system settings. The layout file [mailer.html.erb](../app/views/layouts/mailer.html.erb) has classes that get overriden depending on **light or dark mode** and will display some text, buttons and other components in appropriate colors.

**Light Mode email example**

<img src="../docs/images/email_light.png" width="500" />

**Dark Mode email example**

<img src="../docs/images/email_dark.png" width="500" />

## Primary CTA button

To use the default CTA button, use the partial [\_cta_button.html.haml](../app/views/layouts/mailer/_cta_button.html.haml). The **text** and **url** are passed as variables to the partial like so:
`= render 'layouts/mailer/cta_button', text: 'Example button text', url: example_path`

## Email Delivery in production

We use [Postmark](https://github.com/ActiveCampaign/postmark-rails) gem to deliver emails in production. The only config that needs to be setup is to store your postmark `api_token` in rails production credentials. You can get your `api_token` by signing up on the [Postmark website](https://postmarkapp.com/) for an account.

If you'd like to use a different **mail delivery service**, you can change the `config.action_mailer.delivery_method` in [production.rb](../config/environments/production.rb) to the service of your choice and add any additional config required by the new service like setting the **API keys**. Remove `config.action_mailer.postmark_settings` as it won't be required anymore.
