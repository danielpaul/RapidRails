# app/services/anonymization_service.rb
class AnonymizationService
  def self.anonymize_user(user_id)
    user = User.find_by(id: user_id)

    return if user.nil? || user.anonymized_at.present?

    user.full_name = 'Deleted User'
    user.email = generate_anonymized_email(user.id)
    user.password = SecureRandom.hex(10)
    user.ip_address = nil
    user.unconfirmed_email = nil
    user.reset_password_token = nil
    user.confirmation_token = nil

    user.anonymized_at = Time.current
    user.save
  end

  private

  def self.generate_anonymized_email(user_id)
    email = "#{user_id}@deleted.example.com"

    while User.exists?(email: email)
      email = "#{user_id}+#{generate_random_number}@deleted.example.com"
    end

    email
  end

  def self.generate_random_number
    rand(1..9999)
  end
end
  