class Post < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :likes, as: :contentable
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(id: Current.current_user_id) }, through: :likes, source: :user
  validates :creator_id, numericality: { only_integer: true }
  validates :content, presence: true
end
