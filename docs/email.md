# Emails

## Local Testing

We use the gem [Letter Opener Web](https://github.com/fgrehm/letter_opener_web) to deliver emails in development for testing purposes. It provides a web interface based on the original [Letter Opener](https://github.com/ryanb/letter_opener) gem. All delivered emails can be accessed at `localhost:3000/letter_opener`.

## Email Styles

We have a mailer layout that supports both **Dark Mode** and **Light Mode** settings in the email client or based on system settings. The layout file [mailer.html.erb](../app/views/layouts/mailer.html.erb) has classes that get overriden depending on **light or dark mode** and will display some text, buttons and other components in appropriate colors.

## Primary CTA button

To use the default CTA button, use the partial located at [\_cta_button.html.haml](../app/views/layouts/mailer/_cta_button.html.haml). The text and url are passed as variables to the partial.

## Email Delivery in production

We use [Postmark](https://github.com/ActiveCampaign/postmark-rails) gem to deliver emails in production. The only config that needs to be setup is to store your postmark `api_token` in rails production credentials. You can get your `api_token` by signing up on the [Postmark website](https://postmarkapp.com/) for an account.
