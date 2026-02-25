class Followship < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: "User"
  validates_uniqueness_of :user_id, scope: :follower_id
  validates :user_id, :follower_id, presence: true
  validates :id, :user_id, :follower_id, numericality: { only_integer: true }
end
