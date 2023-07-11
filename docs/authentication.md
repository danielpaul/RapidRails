# Authentication

## Devise

[Devise](https://github.com/heartcombo/devise) is a flexible authentication solution that provides a full-featured authentication system that provides a complete MVC solution based on Rails engines. Some of the modules it includes:

1. **Database Authenticatable**: Encrypts and stores a password in the database to validate the authenticity of a user while signing in.

2. **Registerable**: Handles signing up users through a registration process, also allowing them to edit and destroy their account.

3. **Recoverable**: Resets the user's password and sends reset instructions.

4. **Rememberable**: Manages generating and clearing a token for remembering the user from a saved cookie.

5. **Trackable**: Tracks sign in count, timestamps, and IP address.

6. **Confirmable**: Sends emails with confirmation instructions and verifies whether an account is already confirmed during sign in.

7. **Lockable**: Locks an account after a specified number of failed sign-in attempts.

8. **Timeoutable**: Expires sessions that have not been active in a specified period.

9. **Validatable**: Provides validations of email and password.

10. **Omniauthable**: Adds OmniAuth support.

Here is an example of how Devise is used in our User model:

```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :omniauthable
end
```

Devise is customizable, allowing you to add or remove modules that best suit your application. Devise provides many helper methods like `user_signed_in?` that checks if a user is signed in or `current_user` that returns the **User** record of the signed in user.

### Configuration

In the provided codebase, devise in configured in `config/initializers/devise.rb`.

1. If using the Rails mailer, don't forget to set the value of the constant `DEFAULT_FROM_EMAIL` for your application.

2. If modifying anything related to the sign up or confirmation process, refer to the controllers `RegistrationsController` and `ConfirmationsController` which override and/or inherits from their original devise controllers.

## Omniauth

Google OmniAuth is a strategy for OmniAuth, a Ruby authentication framework. It provides a standardized interface for different types of authentication.

Google OmniAuth is used to authenticate users via Google's OAuth 2.0 API. This means users can sign in to your application using their Google account credentials. This simplifies the sign-in process for users, as they don't need to remember another username/password.

### Configuration

In the provided codebase, Google OmniAuth is configured in the same file as devise `config/initializers/devise.rb`.

```
config.omniauth :google_oauth2,
  Rails.application.credentials.dig(Rails.env.to_sym, :google, :client_id),
  Rails.application.credentials.dig(Rails.env.to_sym, :google, :client_secret),
  scope: "email, profile"
```

1. The `client_id` and `client_secret` should be setup via the [Google API console](https://console.developers.google.com/) and then stored in the credentials file. You can follow [this tutorial](https://fwuensche.medium.com/how-to-use-google-oauth-on-rails-c6e07047e4fb) to set up your google client keys on the **Google API console** or get them from your admin if the keys are already setup.
2. The google oauth callback creates a **User** record using the `User.from_omniauth(data)` method that can be found in the `User::Omniauthable` concern. You may customize this method according to the requirements of your app.
