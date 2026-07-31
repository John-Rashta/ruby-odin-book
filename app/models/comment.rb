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
  after_destroy_commit :delete_comment

  private

  def delete_comment
    broadcast_remove_to(
      "comment-#{self.id}",
      target: "comment-#{self.id}"
    )

    broadcast_action_to(
      "comment-show-#{self.id}",
      action: "redirect_to_home",
      html: ""
    )
  end
end
