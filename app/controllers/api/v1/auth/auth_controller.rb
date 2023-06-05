class Api::V1::Auth::AuthController < Api::V1::BaseController
  before_action :set_user!, except: %i[extend_token sign_in_via_email_code]
  before_action :set_user_for_verification_code!, only: :sign_in_via_email_code
  before_action :set_user_from_token!, only: %i[extend_token user update_user]
  before_action :render_unauthorized_user!, only: %i[sign_in sign_in_via_email_code]
  before_action :authorize_confirmed_user!, only: :sign_in

  def sign_in
    if current_user.valid_password?(auth_params[:password])
      # Render JWT token with expiry and user's email
      set_user_token!
    else
      render_unauthorized!(
        message: "Oops. That doesn't look like the correct password. " \
        "Please try again or you can request to reset your password."
      )
    end
  end

  def forgot_password
    current_user&.send_reset_password_instructions
    render_ok!({message: t("devise.passwords.send_paranoid_instructions")})
  end

  def confirm_email
    current_user&.send_confirmation_instructions
    render_ok!({message: t("devise.confirmations.send_paranoid_instructions")})
  end

  def send_verification_code
    # Send the verification code to the user via email
    VerificationCodeService.new(user_id: current_user.id).send_verification_code! if current_user
    render_ok!({message: t("verification_codes.create.notice_message")})
  end

  def sign_in_via_email_code
    # Render JWT token if the verification code is valid
    if current_user.verification_code_valid?
      set_user_token!
    else
      render_unauthorized!
    end
  end

  def extend_token
    # Gets JWT token from header and return a new JWT token
    set_user_from_token!
    set_user_token!
  end

  def user
    render_ok!(
      {
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        avatar_url: current_user.avatar_url
      }
    )
  end

  def update_user
    if current_user.update(user_params)
      render_ok!({message: t("devise.registrations.updated")})
    else
      render_unprocessable_entity!(message: current_user.errors.full_messages.join(", "))
    end
  end

  private

  def auth_params
    params.permit(:email, :password, :verification_code)
  end

  def user_params
    params.permit(:first_name, :last_name, :password, :password_confirmation)
  end

  def set_user!
    # Find user from email
    @user = User.find_by_email(auth_params[:email]&.downcase)
  end

  def set_user_for_verification_code!
    # Find user from email and verification code
    @user = User.where.not(magic_link_token: nil)
      .where(
        email: auth_params[:email],
        magic_link_token: auth_params[:verification_code]
      )
      .first
  end

  def set_user_from_token!
    # Set user from JWT token
    token = request.headers["Authorization"].split(" ").last
    payload = JwtTokenService.decode!(token)[0]
    @user = User.find(payload["id"])
  rescue JWT::DecodeError
    # If invalid bearer token
    render_unauthorized!
  end

  def render_unauthorized_user!
    render_unauthorized! unless current_user
  end

  def authorize_confirmed_user!
    render_unprocessable_entity!(message: t("devise.failure.unconfirmed")) unless current_user.confirmed?
  end
end
