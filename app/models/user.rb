class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_many :requests, dependent: :destroy
  has_many :sent_requests, foreign_key: "sender_id", class_name: "Request", dependent: :destroy
  has_many :followships, dependent: :destroy
  has_many :followers, through: :followships
  has_many :inverse_followships, foreign_key: "follower_id", class_name: "Followship", dependent: :destroy
  has_many :followings, through: :inverse_followships, source: :user
  has_many :created_posts, foreign_key: "creator_id", class_name: "Post", dependent: :destroy
  has_many :created_comments, foreign_key: "creator_id", class_name: "Comment", dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :contentable, source_type: "Post"
  has_many :liked_comments, through: :likes, source: :contentable, source_type: "Comment"
  has_many :followed, -> { where(follower_id: Current.current_user_id) }, class_name: "Followship"
  has_many :follow_request_by_current, -> { where(sender_id: Current.current_user_id, table_type: "follow") }, class_name: "Request"
  has_one_attached :avatar
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validate :avatar_type
  validate :avatar_size

  def avatar_type
    if avatar.attached? && ![ "image/jpg", "image/jpeg", "image/png", "image/webp" ].include?(avatar.content_type)
      errors.add(:avatar, "Type has to be JPG, JPEG, PNG or WEBP")
    end
  end

  def avatar_size
    if avatar.attached? && avatar.byte_size > 5.megabytes
      errors.add(:avatar, "Image size limit is 5MB.")
    end
  end
end
