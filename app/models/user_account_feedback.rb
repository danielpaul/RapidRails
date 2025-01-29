# == Schema Information
#
# Table name: user_account_feedbacks
#
#  id         :bigint           not null, primary key
#  feedback   :string
#  created_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_account_feedbacks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class UserAccountFeedback < ApplicationRecord
  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    %w[
      feedback
      created_at
    ]
  end
end
