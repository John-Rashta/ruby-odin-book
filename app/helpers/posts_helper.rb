module PostsHelper
  # Validate image and content - check if image is correct size and type and if content isn't empty
  def validate_params(params)
    if !params || !params.has_key?(:image) && !params.has_key?(:content)
      return { valid: false, message: "Missing data." }
    end
    if params.has_key?(:image) && !validate_image?(params[:image])
      return { valid: false, message: "Incorrect image type or image size." }
    end
    if params.has_key?(:content) && params[:content].blank?
      return { valid: false, message: "Content can't be empty!" }
    end
    { valid: true }
  end
end
