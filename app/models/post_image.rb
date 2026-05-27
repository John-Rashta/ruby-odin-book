class PostImage < ApplicationRecord
  include ActiveModel::Validations
  before_destroy -> { image.purge_later }
  has_one_attached :image
  has_one :post, as: :postable
  validates_with ImageValidator, custom_type: "image"
end
