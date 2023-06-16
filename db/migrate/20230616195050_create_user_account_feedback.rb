class CreateUserAccountFeedback < ActiveRecord::Migration[7.0]
  def change
    create_table :user_account_feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :feedback

      t.datetime :created_at, null: false
    end
  end
end
