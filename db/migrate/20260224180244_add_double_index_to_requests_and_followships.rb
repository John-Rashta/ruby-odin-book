class AddDoubleIndexToRequestsAndFollowships < ActiveRecord::Migration[8.1]
  def change
    add_index :requests, [ :user_id, :sender_id, :type ], unique: true
    add_index :followships, [ :user_id, :follower_id ], unique: true
  end
end
