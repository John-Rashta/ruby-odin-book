class RequestsController < ApplicationController
  # DO BUTTONS TO CANCEL SENT AND REFUSE RECEIVED
  protect_from_forgery with: :exception
  def index
    @requests = current_user.requests.includes(:sender)
  end

  def sent_requests
    @sent_requests = current_user.sent_requests.includes(:user)
  end
  # CHECK WHO CURRENT USER IS, IF SENDER OR RECEIVER AND BROADCAST ACCORDINGLY
  def destroy
    this_params = destroy_params
    @request = Request.where(id: params[:id]).and(Request.where(user_id: current_user.id).or(Request.where(sender_id: current_user.id))).first
    respond_to do |format|
      if @request && @request.destroy
        flash.now[:notice] = "Sucessfully deleted request!"
        format.turbo_stream
        format.html { head :ok }
        RequestsBroadcastJob.perform_later(
          current_user,
          helpers.get_other_user_from_request(current_user, @request),
          { action: "destroy", requestId: @request.id })
      else
        flash[:alert] = "Failed to delete request!"
        format.html { head :bad_request }
        if other_user = User.find_by(id: this_params[:user_id])
          format.turbo_stream {
            render :request_failure, locals: { current_user: current_user, user: other_user, request_id: params[:id] }, status: :unprocessable_entity
          }
        end
      end
    end
  end

  def create
    this_params = create_params
    respond_to do |format|
      if this_params[:user_id].to_i == current_user.id
        flash[:alert] = "Can't send request to yourself!"
        format.html { head :bad_request }
      else
        @request = current_user.sent_requests.create_or_find_by(create_params)
        if @request.previously_new_record?
          flash.now[:notice]= "Sucessfully sent request!"
          format.turbo_stream
          format.html { head :ok }
          RequestsBroadcastJob.perform_later(
            current_user,
            helpers.get_other_user_from_request(current_user, @request),
          )
        else
          flash[:alert] = "Failed to send request!"
          format.html { head :bad_request }
          # USE CREATE_OR_FIND_BY AND IF NOTHING FOUND JUST DELETE ASWELL- THO MAYBE ALWAYS DELETE- WILL SEE
          if other_user = User.find_by(id: this_params[:user_id])
            format.turbo_stream {
              render turbo_stream: turbo_stream.replace("user-follow-form-#{other_user.id}", partial: "users/form", locals: { current_user: current_user, user: other_user }), status: :unprocessable_entity
            }
          end
        end
      end
    end
  end

  private
  def create_params
    params.expect(request: [ :user_id, :table_type ])
  end

  def destroy_params
    params.expect(request: [ :user_id ])
  end
end
