class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :api_key, null: false
      t.index [:api_key], unique: true

      t.string :name, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
