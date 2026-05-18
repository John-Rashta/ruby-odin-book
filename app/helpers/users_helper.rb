module UsersHelper
  def create_avatar(avatar)
    image = Vips::Image.new_from_file avatar.path
      if image.width > 300 || image.height > 300
        # thumbnail faster than thumbnail_image on Image
        image = Vips::Image.thumbnail avatar.path, 300, height: 300, crop: "centre"
      end
      cx = image.width / 2
      cy = image.height / 2
      r = [ cx, cy ].min
      mask = Vips::Image.svgload_buffer <<-EOS
      <svg viewBox="0 0 #{image.width} #{image.height}">
          <circle cx="#{cx}" cy="#{cy}" r="#{r}" fill="#000" />
      </svg>
      EOS

      # use the alpha from the svg as the alpha for our image
      { image: image, mask: mask }
  end

  def validate_image?(image)
    unless [ "jpg", "jpeg", "png", "webp" ].include?(image.original_filename.split(".")[-1]) && image.size <= 5.megabytes
      false
    else
      true
    end
  end
end
