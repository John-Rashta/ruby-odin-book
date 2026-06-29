class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :creator, class_name: "User"
  has_many :likes, as: :contentable, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(user_id: Current.current_user_id) }, as: :contentable, class_name: "Like"
  has_many :comments, dependent: :destroy
  has_many :direct_comments, -> { where(comment_id: nil).order(created_at: :desc) }, foreign_key: "post_id", class_name: "Comment", dependent: :destroy
  validates :creator_id, numericality: { only_integer: true }
  belongs_to :postable, polymorphic: true, dependent: :destroy
  # after_create_commit :add_post
  # after_update_commit :update_post
  after_destroy_commit :delete_post

  private

  def add_post
    PostCreationJob.perform_later(self)
  end

  def update_post
  end

  def delete_post
    broadcast_remove_to(
      "post-#{self.id}",
      target: "post-#{self.id}"
    )

    broadcast_action_to(
      "post-show-#{self.id}",
      action: "redirect_to_home",
      html: ""
    )
  end
end
