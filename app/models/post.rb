class Post < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :likes, as: :contentable, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(id: Current.current_user_id) }, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :direct_comments, -> { where(comment_id: nil) }, foreign_key: "post_id", class_name: "Comment", dependent: :destroy
  validates :creator_id, numericality: { only_integer: true }
  validates :content, presence: true
end
