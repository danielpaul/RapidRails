class AnonymizationService
  def self.anonymize_user(user_id)
    user = User.find(user_id)

    return if user.nil? || user.anonymized_at.present?

    user.assign_attributes(
      full_name: "Deleted User",

      email: generate_anonymized_email(user.id),
      unconfirmed_email: nil,
      password: Devise.friendly_token[0, 20],

      current_sign_in_ip: nil,
      last_sign_in_ip: nil,

      reset_password_token: nil,
      confirmation_token: nil,

      anonymized_at: Time.current
    )

    user.save(validate: false)
  end

  private

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
