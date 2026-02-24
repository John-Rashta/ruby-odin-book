class CreateFollowships < ActiveRecord::Migration[8.1]
  def change
    create_table :followships do |t|
      t.timestamps
      t.references :user, null: false, index: true, foreign_key: true
      t.references :follower, null: false, index: true, foreign_key: { to_table: :users }
    end
  end
end
