# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  anonymized_at           :datetime
#  confirmation_sent_at    :datetime
#  confirmation_token      :string
#  confirmed_at            :datetime
#  current_sign_in_at      :datetime
#  current_sign_in_ip      :string
#  discarded_at            :datetime
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  full_name               :string           not null
#  last_sign_in_at         :datetime
#  last_sign_in_ip         :string
#  onboarding_completed_at :datetime
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  sign_in_count           :integer          default(0), not null
#  unconfirmed_email       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_anonymized_at         (anonymized_at)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Hashid::Rails
  has_paper_trail
  include Discard::Model

  include User::Omniauthable
  include User::Onboarding
  include User::Offboarding
  include User::Avatar

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :trackable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  validates :full_name, presence: true, length: {maximum: 100}
  validate :full_name_does_not_have_urls

  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: true

  def first_name
    full_name_parts.first
  end

  def last_name
    (full_name_parts.length > 1) ? full_name_parts.last : nil
  end

  def email_name_greeting
    if first_name && first_name.length <= 15
      first_name
    else
      "Friend"
    end
  end

  def initials
    full_name_parts.map(&:first).join
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      email
      full_name
      sign_in_count
      current_sign_in_at
      created_at
      onboarding_completed_at
    ]
  end

  private

  def full_name_parts
    return [] if full_name.blank?

    full_name.split(" ")
  end

  def full_name_does_not_have_urls
    return unless full_name.present?

    urls = URI.extract(full_name, ["http", "https"])
    return if urls.blank?

    errors.add(:full_name, "cannot contain URLs")
  end
end
