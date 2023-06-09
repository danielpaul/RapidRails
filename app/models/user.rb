# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discarded_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Hashid::Rails
  include Discard::Model
  has_paper_trail

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :full_name, presence: true, length: { maximum: 100 }

  def first_name
    full_name_parts.first
  end

  def last_name
    full_name_parts.length > 1 ? full_name_parts.last : nil
  end

  def initials
    full_name_parts.map(&:first).join
  end

  def active_for_authentication?
    super && !discarded?
  end
  
  def avatar_url
    # Don't share real names. Just initials. 
    # Add hash to get unique color variant for each user. Otherwise all DP will be same.
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://api.dicebear.com/6.x/initials/png?backgroundType=gradientLinear&seed=#{initials + hash}"
  end

  private

  def full_name_parts
    full_name.split(' ')
  end
end
