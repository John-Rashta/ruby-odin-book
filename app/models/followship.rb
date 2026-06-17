class Followship < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :follower, class_name: "User"
  validates_uniqueness_of :user_id, scope: :follower_id
  validates :user_id, :follower_id, presence: true
  validates :user_id, :follower_id, numericality: { only_integer: true }
  after_create_commit :broadcast_to_follower
  after_destroy_commit :broadcast_to_receiver

  private

  def broadcast_to_follower
    Current.current_user_id = self.follower.id
    broadcast_append_to(
      "followships-#{self.follower_id}",
      target: "followships-#{self.follower_id}",
      partial: "users/user",
      locals: { user: self.user, current_user: self.follower, custom_start: "follows-user-" }
    )
  end

  def broadcast_to_receiver
    broadcast_remove_to(
      "followers-#{self.user_id}",
      target: "followers-user-#{self.follower_id}",
    )
  end
end
