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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    full_name { Faker::Name.name }
    current_sign_in_ip { Faker::Internet.ip_v4_address }
    last_sign_in_ip { Faker::Internet.ip_v4_address }
    onboarding_completed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
      unconfirmed_email { nil }
    end
  end
end
