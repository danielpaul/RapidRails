class AdminUser < ApplicationRecord
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable

  def email_name_greeting
    "Admin (#{email})"
  end
end
