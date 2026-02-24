class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.timestamps
      t.references :user, null: false, index: true, foreign_key: true
      t.references :sender, null: false, index: true, foreign_key: { to_table: :users }
      t.integer :type, default: 0, null: false
    end
  end
end
# NEED TO ADD TYPE ASWELL WHICH IS AN ENUM
