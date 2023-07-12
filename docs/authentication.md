# Authentication

## Devise

We use [Devise](https://github.com/heartcombo/devise) as our primary authentication solution.

### Configuration

In the provided codebase, devise in configured in `config/initializers/devise.rb`.

1. If using the Rails mailer, don't forget to set the value of the constant `DEFAULT_FROM_EMAIL` for your application.

2. If modifying anything related to the sign up or confirmation process, refer to the controllers `RegistrationsController` and `ConfirmationsController` which override and/or inherits from their original devise controllers.

## Omniauth

[Google OmniAuth](https://github.com/zquestz/omniauth-google-oauth2) is used to sign in to your application using their Google account credentials.

### Configuration

If you don't want to use google omniauth, you can remove the **Sign in with google button** on the **Sign in/Sign up** page.

1. Client Keys for google oauth be setup via the [Google API console](https://console.developers.google.com/). You can follow [this tutorial](https://fwuensche.medium.com/how-to-use-google-oauth-on-rails-c6e07047e4fb) to set up your google client keys or get them from your admin if the keys are already setup.

2. Open your credentials file and store the keys nested under the **environment** and under `google` as `client_id` and `client_secret`

3. The google oauth callback creates a **User** record using the `User.from_omniauth(data)` method that can be found in the `User::Omniauthable` concern. You may customize this method according to the requirements of your app.
