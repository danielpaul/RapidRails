# Authentication

## Devise

We use [Devise](https://github.com/heartcombo/devise) as our primary authentication solution.

### Configuration

In the provided codebase, devise in configured in [config/initializers/devise.rb](../config/initializers/devise.rb).

If modifying anything related to the sign up, confirmation or omniauth process, refer to the controllers [RegistrationsController](../app/controllers/registrations_controller.rb), [ConfirmationsController](../app/controllers/confirmations_controller.rb) or [Users::OmniauthCallbacksController](../app/controllers/users/omniauth_callbacks_controller.rb) which override and/or inherits from their original devise controllers.

- In the [ConfirmationsController](../app/controllers/confirmations_controller.rb), we have overridden some `after_confirmation` paths to use our custom paths. We also a new action `confirm_email` that renders a custom view after confirmation.
- In the [RegistrationsController](../app/controllers/registrations_controller.rb), we have overridden the `destroy` action to validate current password. If validated, it soft-deletes the record and sets a custom flash message and if not valid, it renders the edit page and flashes an error message. We also have a new action `cancel_email_change!` that cancels a pending request to change the user's email. We also have some methods related to updating the user to use some custom params and also some paths like **after\_update\_path_for**.
- In the [Users::OmniauthCallbacksController](../app/controllers/users/omniauth_callbacks_controller.rb), we have overridden the `google_oauth2` action to handle for unconfirmed users and ask them to confirm their email if required or to throw any errors if the sign up fails to create a user record.

## Omniauth

[Google OmniAuth](https://github.com/zquestz/omniauth-google-oauth2) is used to sign in to your application using their Google account credentials.

### Configuration

If you don't want to use google omniauth, you can remove the [Sign in with google](../app/views/devise/shared/_social_login.html.haml) button on the [Sign in](../app/views/devise/registrations/new.html.erb) and [Sign up](../app/views/devise/sessions/new.html.haml) pages.

1. Client Keys for google oauth be setup via the [Google API console](https://console.developers.google.com/). You can follow [this tutorial](https://fwuensche.medium.com/how-to-use-google-oauth-on-rails-c6e07047e4fb) to set up your google client keys or get them from your admin if the keys are already setup.

2. Open your credentials file and store the keys nested under the **environment** and under `google` as `client_id` and `client_secret`

3. The google oauth callback creates a **User** record using the [User.from_omniauth(data)](../app/models/concerns/user/omniauthable.rb) method that can be found in the `User::Omniauthable` concern. It copies over name and email data from google and also attaches the avatar image as a profile picture through a Sidekiq job. You may customize this method according to the requirements of your app.
