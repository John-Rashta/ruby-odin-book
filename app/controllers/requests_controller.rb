class RequestsController < ApplicationController
  # DO BUTTONS TO CANCEL SENT AND REFUSE RECEIVED
  def index
    @requests = current_user.requests.includes(:sender)
  end

  def sent_requests
    @sent_requests = current_user.sent_requests.includes(:user)
  end
  def destroy
    @request = Request.where(id: params[:id]).and(Request.where(user_id: current_user.id).or(Request.where(sender_id: current_user.id))).first
    respond_to do |format|
      if @request && @request.destroy
        flash.now[:notice] = "Sucessfully deleted request!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to delete request!"
        format.html { head :bad_request }
      end
    end
  end

  def create
    @request = current_user.sent_requests.build(create_params)
    respond_to do |format|
      if @request.save
        flash.now[:notice]= "Sucessfully sent request!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to send request!"
        format.html { head :bad_request }
      end
    end
  end

  private
  def create_params
    params.expect(request: [ :user_id, :table_type ])
  end
end
