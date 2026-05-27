module PostsHelper
  def validate_params(params)
    if params.has_key?(:image) && !validate_image?(params[:image])
      return { valid: false, message: "Incorrect image type or image size." }
    end
    if params.has_key?(:content) && params[:content].blank?
      return { valid: false, message: "Content can't be empty!" }
    end
    if !params.has_key?(:image) && !params.has_key?(:content)
      { valid: false, message: "Missing data." }
    end
    { valid: true }
  end
end
