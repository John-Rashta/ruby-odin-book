class Post < ApplicationRecord
  belongs_to :creator, class_name: "User"
  validates :creator_id, numericality: { only_integer: true }
  validates :content, presence: true
end
