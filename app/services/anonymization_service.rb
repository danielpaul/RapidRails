class AnonymizationService
  def self.anonymize_user(user_id)
    user = User.where(id: user_id).first

    return if user.nil? || user.anonymized_at.present?

    # does not run validations
    user.update_columns(
      full_name: "Deleted User",

      email: generate_anonymized_email(user.id),
      unconfirmed_email: nil,
      encrypted_password: Devise::Encryptor.digest(User, SecureRandom.hex(32)),

      current_sign_in_ip: nil,
      last_sign_in_ip: nil,

      reset_password_token: nil,
      confirmation_token: nil,

      anonymized_at: Time.current
    )
  end

  private_class_method :generate_anonymized_email

  def self.generate_anonymized_email(prefix, domain = "deleted.example.com")
    email = "#{prefix}@#{domain}"
    counter = 1

    while User.exists?(email: email)
      email = "#{prefix}+#{counter}@#{domain}"
      counter += 1
    end

    email
  end
end
