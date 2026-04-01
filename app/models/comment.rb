class Comment < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :post, counter_cache: true
  belongs_to :comment, optional: true, counter_cache: true
  has_many :likes, as: :contentable, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :liked, -> { where(id: Current.current_user_id) }, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  validates :creator_id, numericality: { only_integer: true }
  validates :content, presence: true
end
