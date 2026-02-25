class Request < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: "User"
  validates_uniqueness_of :user_id, scope: [ :sender_id, :table_type ]
  enum :table_type, { follow: 0 }
  validates :user_id, :sender_id, :table_type, presence: true
  validates :table_type, inclusion: { in: %w[follow] }
  validates :user_id, :sender_id, :id, numericality: { only_integer: true }
end
