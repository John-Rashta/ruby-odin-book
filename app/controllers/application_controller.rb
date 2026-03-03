class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def handle_argument_error
    head :bad_request
    flash[:alert] = "Something Went Wrong!"
  end

  def record_not_found
    flash[:alert] = "Record not found."
    head :not_found
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end
end
