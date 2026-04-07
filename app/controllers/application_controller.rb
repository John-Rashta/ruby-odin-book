class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_id, if: :user_signed_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def set_current_id
    Current.current_user_id = current_user.id unless Current.current_user_id == current_user.id
  end

  def handle_argument_error
    head :bad_request
    flash[:alert] = "Something Went Wrong!"
  end

  def record_not_unique
    flash[:alert] = "Invalid Values."
    head :bad_request
  end

  def record_not_found
    flash[:alert] = "Record not found."
    head :not_found
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email ])
  end
end
