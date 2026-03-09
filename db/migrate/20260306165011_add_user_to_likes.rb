class AddUserToLikes < ActiveRecord::Migration[8.1]
  def change
    add_reference :likes, :user, null: false
    add_index :likes, [ :contentable_id, :contentable_type, :user_id ], unique: true
  end
end
