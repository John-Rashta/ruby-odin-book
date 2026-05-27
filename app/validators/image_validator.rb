class ImageValidator < ActiveModel::Validator
  def validate(record)
    image = record.send(options[:custom_type])
    if image.attached?
      if image.byte_size > 5.megabytes
        record.errors.add(options[:custom_type], "Image size limit is 5MB.")
      end

      if ![ "image/jpg", "image/jpeg", "image/png", "image/webp" ].include?(image.content_type)
        record.errors.add(options[:custom_type], "Type has to be JPG, JPEG, PNG or WEBP")
      end
    end
  end
end
