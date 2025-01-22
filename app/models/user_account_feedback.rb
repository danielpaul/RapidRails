# == Schema Information
#
# Table name: user_account_feedbacks
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  feedback   :string
#  created_at :datetime         not null
#
# Indexes
#
#  index_user_account_feedbacks_on_user_id  (user_id)
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
