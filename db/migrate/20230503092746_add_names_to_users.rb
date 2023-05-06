class AddNamesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string, null: false, blank: false
  end
end
