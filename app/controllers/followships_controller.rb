class FollowshipsController < ApplicationController
  def index
    @follows = current_user.followings
  end

  def followers
    @followers = current_user.followers
  end
  def destroy
    @followship = current_user.inverse_followships.find_by!(destroy_params)
    if @followship.destroy
      flash[:notice] = "Sucessfull Unfollow!"
    else
      flash[:alert] = "Failed to unfollow!"
      head :bad_request
    end
  end

  def create
    @request = current_user.requests.includes(:sender).find(create_params[:id])

    @followship = current_user.followships.build(follower_id: @request.sender.id)
    if @followship.save && @request.destroy
      flash[:notice] = "Accepted Follow!"
    else
      @followship.destroy
      flash[:alert] = "Failed to accept follow!"
      head :bad_request
    end
  end

  private

  def destroy_params
    params.expect(follow: [ :user_id ])
  end

  def create_params
    params.expect(request: [ :id ])
  end
end
