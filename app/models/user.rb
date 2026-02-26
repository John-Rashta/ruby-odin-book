class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_many :requests, dependent: :destroy
  has_many :sent_requests, foreign_key: "sender_id", class_name: "Request", dependent: :destroy
  has_many :followships
  has_many :followers, through: :followships
  has_many :inverse_followships, foreign_key: "follower_id", class_name: "Followship", dependent: :destroy
  has_many :followings, through: :inverse_followships, source: :user
end
