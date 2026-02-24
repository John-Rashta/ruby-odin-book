class Request < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: "User"
  validates_uniqueness_of :user_id, scope: [ :sender_id, :type ]
  enum :type, { follow: 0 }
end
