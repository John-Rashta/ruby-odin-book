class Like < ApplicationRecord
  belongs_to :contentable, polymorphic: true
  belongs_to :user
end
