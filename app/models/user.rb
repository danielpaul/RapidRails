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
  include Discard::Model
  has_paper_trail

  include User::Omniauthable
  include User::Onboarding

  attr_accessor :feedback

  has_one_attached :profile_picture
  has_many :user_account_feedbacks

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :trackable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  validates :full_name, presence: true, length: {maximum: 100}
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: true
  validates :profile_picture,
    content_type: {
      in: ["image/png", "image/jpg", "image/jpeg"],
      message: "must be a png, jpg, or jpeg image file"
    },
    size: {less_than: 10.megabytes}

  def first_name
    full_name_parts.first
  end

  def last_name
    (full_name_parts.length > 1) ? full_name_parts.last : nil
  end

  def initials
    full_name_parts.map(&:first).join
  end

  def active_for_authentication?
    super && !discarded?
  end

  def avatar_url
    if profile_picture.attached? && profile_picture.variable?
      # Use ActiveStorage's variant to resize image to 100x100
      return profile_picture.variant(resize_to_fill: [500, 500]).processed
    end

    # Don't share real names. Just initials.
    # Add hash to get unique color variant for each user. Otherwise all DP will be same.
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://api.dicebear.com/6.x/initials/png?backgroundType=gradientLinear&seed=#{initials + hash}"
  end

  private

  def full_name_parts
    return [] if full_name.blank?

    full_name.split(" ")
  end
end
