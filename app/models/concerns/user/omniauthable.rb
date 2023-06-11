module User::Omniauthable
  extend ActiveSupport::Concern

  included do
    def self.from_omniauth(data)
      # Return or create user from google_oauth data and confirm userif required
      # we use email as the unique identifier

      # find user record that matches the email case-insensitive
      user = User.where("lower(email) = ?", data["email"].downcase).first

      user_verified_email = (data['email_verified'] == true)

      # if user is not found and the user has not confirmed their email address, confirm
      # the user account and reset password - we don't want another user who might have created
      # the account and left it to be able to get in with the password that they set
      if user && !user.confirmed? && user_verified_email
        user.confirm

        # reset the password to a random password and skip sending email
        user.password = Devise.friendly_token[0, 20]
        user.skip_confirmation_notification!
        user.save!
      end

      # if the user account is not found, create a new user account and confirm it
      # confirmed because the user's email is Google account
      if user.nil?
        user = User.new(
          full_name: data["name"],
          email: data["email"],
          password: Devise.friendly_token[0, 20], # random password
        )

        user.confirmed_at = Time.now.utc if user_verified_email

        user.save!
      end

      # if the user profile picture exists, user has not uploaded another profile_picture, save it
      if user && !user.profile_picture.attached? && data["image"].present?
        # sidekiq job to download the image and attach it to the user
        # log the user in ASAP without waiting for slow image request and attachment process
        # to complete. The user will see the default avatar until the image is attached.
        AttachProfilePictureJob.perform_later(user.id, data["image"])
      end

      user
    end
  end
end