class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_id, if: :user_signed_in?
  around_action :append_flashes
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
    respond_to do |format|
      flash[:alert] = "Something Went Wrong!"
      format.turbo_stream { head :bad_request }
      format.html { head :bad_request }
    end
  end

  def record_not_unique
    respond_to do |format|
      flash[:alert] = "Invalid Values."
      format.turbo_stream { head :bad_request }
      format.html { head :bad_request }
    end
  end

  def record_not_found
    respond_to do |format|
      flash[:alert] = "Record not found."
      format.turbo_stream { head :not_found }
      format.html { head :not_found }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email ])
  end

  private

  def append_flashes
    yield

    return unless response.media_type == "text/vnd.turbo-stream.html"

    return if response.status.in?(300..399)

    flash.each do |type, message|
      stream_tag = helpers.turbo_stream.update("#{type}", html: message)

      response.body = "#{response.body}#{stream_tag}"
    end

    flash.discard
  end
end
