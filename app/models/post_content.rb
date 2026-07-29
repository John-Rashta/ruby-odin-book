class PostContent < ApplicationRecord
  has_rich_text :content
  has_one :post, as: :postable
  validate :content_cant_be_empty
  validate :validate_content_attachments

  private

  def content_cant_be_empty
    if content&.to_s.blank? || content&.to_plain_text.blank?
      errors.add(:content, "Can't be empty.")
    end
  end

  def validate_content_attachments
    return unless content.present?

    content.embeds.each do |content|
      if content.image? == false
        errors.add(:content, "can only contain image attachments.")
        break
      end

      if content.blob.byte_size > 5.megabytes
        errors.add(:content, "images must be smaller than 5MB.")
        break
      end
    end
  end
end
