# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  api_key    :string           not null
#  name       :string           not null
#  status     :integer          default("active")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :api_key do
    name { Faker::Company.name }
  end
end
