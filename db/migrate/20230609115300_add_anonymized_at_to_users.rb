class AddAnonymizedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :anonymized_at, :datetime
    add_index :users, :anonymized_at
  end
end
