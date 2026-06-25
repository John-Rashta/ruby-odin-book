class PostContent < ApplicationRecord
  has_rich_text :content
  has_one :post, as: :postable
  validate :content_cant_be_empty

  private

  def content_cant_be_empty
    if content&.to_s.blank? || content&.to_plain_text.blank?
      errors.add(:content, "Can't be empty.")
    end
  end
end
