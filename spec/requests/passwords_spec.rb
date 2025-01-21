require 'rails_helper'
require 'mail'

RSpec.describe "Password Reset", type: :request do
  it "confirms email and logs user in after password reset" do
    user = create(:user, :unconfirmed, email: "unconfirmed@example.com")
    reset_token = user.send_reset_password_instructions

    # Update password using the reset token
    response = put user_password_path, params: {
      user: {
        reset_password_token: reset_token,
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    # Reload the user
    user.reload

    # Verify the email is confirmed
    expect(user.confirmed?).to be_truthy

    # Verify the user is logged in
    follow_redirect!
    expect(controller.current_user).to eq(user)
  end

  it "does not confirm email if trying to change email also" do
    user = create(:user, :unconfirmed, email: "unconfirmed@example.com", unconfirmed_email: "new@example.com")
    reset_token = user.send_reset_password_instructions

    # Update password using the reset token
    response = put user_password_path, params: {
      user: {
        reset_password_token: reset_token,
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    # Reload the user
    user.reload

    # Verify the email is not confirmed
    expect(user.confirmed?).to be_falsey

    # Verify the user is not logged in
    follow_redirect!
    expect(controller.current_user).to be_nil
  end
end