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
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_most(100) }
  end

  describe 'associations' do
  end

  describe '#first_name' do
    it 'returns the first name when full name has only first name' do
      user = FactoryBot.build(:user, full_name: 'John')
      expect(user.first_name).to eq('John')
    end

    it 'returns the first name when full name has first and last name' do
      user = FactoryBot.build(:user, full_name: 'John Doe')
      expect(user.first_name).to eq('John')
    end

    it 'returns the first name when full name has first, middle, and last name' do
      user = FactoryBot.build(:user, full_name: 'John Jacob Doe')
      expect(user.first_name).to eq('John')
    end
  end

  describe '#last_name' do
    it 'returns the last name when full name has only first name' do
      user = FactoryBot.build(:user, full_name: 'John')
      expect(user.last_name).to eq(nil)
    end

    it 'returns the last name when full name has first and last name' do
      user = FactoryBot.build(:user, full_name: 'John Doe')
      expect(user.last_name).to eq('Doe')
    end

    it 'returns the last name when full name has first, middle, and last name' do
      user = FactoryBot.build(:user, full_name: 'John Jacob Doe')
      expect(user.last_name).to eq('Doe')
    end
  end
end
