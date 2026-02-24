class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_many :requests, dependent: :destroy
  has_many :sent_requests, foreign_key: "sender_id", dependent: :destroy
  has_many :followships
  has_many :followers, through: :followships
  has_many :inverse_followships, foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :inverse_followships, source: :user
end
