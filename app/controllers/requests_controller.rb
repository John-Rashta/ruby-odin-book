class RequestsController < ApplicationController
  def destroy
    @request = Request.where(destroy_params).and(Request.where(user_id: current_user.id).or(Request.where(sender_id: current_user.id)))
    if @request.destroy
    else
    end
  end

  def create
    @request = current_user.sent_requests.build(create_params)
    if @request.save
    else
    end
  end

  private
  def create_params
    params.expect(request: [ :user_id, :type ])
  end
  def destroy_params
    params.expect(request: [ :id ])
  end
end
