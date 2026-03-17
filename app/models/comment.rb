class Comment < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :post
  belongs_to :comment, optional: true
  has_many :likes, as: :contentable
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(id: Current.current_user_id) }, through: :likes, source: :user
  validates :content, presence: true
end
