class AdminUser < ApplicationRecord
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable

  def email_name_greeting
    "Admin (#{email})"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email current_sign_in_at sign_in_count created_At]
  end
end
