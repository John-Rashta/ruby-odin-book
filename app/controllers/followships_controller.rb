class FollowshipsController < ApplicationController
  def index
    @follows = current_user.followings
  end

  def followers
    @followers = current_user.followers
  end
  def destroy
    @followship = current_user.inverse_followships.find_by(destroy_params)
    if @followship.destroy
    else
    end
  end

  def create
    @filtered_params = follow_params
    return flash[:alert] = "Failed to accept follow request!" unless current_user.requests.find(@filtered_params[:id])
    @followship = current_user.followships.build(follower_id: @filtered_params[:user_id])
    if @followship.save

    else

    end
  end

  private

  def destroy_params
    params.expect(follow: [ :user_id ])
  end

  def create_params
    params.expect(request: [ :id, :user_id ])
  end
end
