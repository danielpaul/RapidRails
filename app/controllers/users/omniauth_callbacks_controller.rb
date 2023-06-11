class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"].info)

    if @user.persisted?
      # if user account is verified, sign in and redirect
      # if not, sent confirmation email and redirect to confirm_email page
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to confirm_email_path(email: @user.email)
      end
    else
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
