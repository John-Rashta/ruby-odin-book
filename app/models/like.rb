class Like < ApplicationRecord
  belongs_to :contentable, polymorphic: true, counter_cache: true
  belongs_to :user
end
