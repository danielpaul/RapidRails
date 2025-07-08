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
# Indexes
#
#  index_api_keys_on_api_key  (api_key) UNIQUE
#
class ApiKey < ApplicationRecord
  enum :status, {active: 0, disabled: 1}

  validates_presence_of :name, :api_key
  validates_length_of :api_key, is: 27
  validates_uniqueness_of :api_key

  before_validation :set_api_key!, on: :create

  private

  def set_api_key!
    self.api_key = "#{Rails.env.production? ? "live" : "test"}_#{SecureRandom.urlsafe_base64}"
  end
end
