class AddFollowersCount < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :followships_count, :integer, default: 0
  end
end
