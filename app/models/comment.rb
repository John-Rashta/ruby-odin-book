class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :creator, class_name: "User"
  belongs_to :post, counter_cache: true
  belongs_to :comment, optional: true, counter_cache: true
  has_many :likes, as: :contentable, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(user_id: Current.current_user_id) }, as: :contentable, class_name: "Like"
  has_many :comments, dependent: :destroy
  validates :creator_id, numericality: { only_integer: true }
  validates :content, presence: true
  # after_create_commit :add_comment
  after_destroy_commit :delete_comment

  private

  # NEEDS TO BE FIXED AND PROBABLY MOVED
  def add_comment
    if self.comment_id
      broadcast_prepend_to(
      "comment-show-comments-#{self.comment_id}",
      partial: "comments/comment",
      target: "comment-show-comments-#{self.comment_id}",

      )
      broadcast_append_to(
      "comment-comments-#{self.comment_id}"
      )
    else
      broadcast_append_to(
      "post-comments-#{self.post_id}"
    )
    end
  end

  def delete_comment
    broadcast_remove_to(
      "comment-#{self.id}",
      target: "comment-#{self.id}"
    )
  end
end
