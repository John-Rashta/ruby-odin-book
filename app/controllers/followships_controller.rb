class FollowshipsController < ApplicationController
  def index
    @follows = current_user.followings.eager_load(:followed, :follow_request_by_current)
  end

  def followers
    @followers = current_user.followers.eager_load(:followed, :follow_request_by_current)
  end
  def destroy
    @followship = current_user.inverse_followships.find_by!(destroy_params)
    respond_to do |format|
      if @followship.destroy
        flash[:notice] = "Sucessfull Unfollow!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to unfollow!"
        format.html { head :bad_request }
      end
    end
  end

  def create
    @request = current_user.requests.includes(:sender).find(create_params[:id])

    @followship = current_user.followships.includes(:sender).build(follower_id: @request.sender.id)
    respond_to do |format|
      if @followship.save && @request.destroy
        flash[:notice] = "Accepted Follow!"
        format.turbo_stream
        format.html { head :ok }
      else
        @followship.destroy
        flash[:alert] = "Failed to accept follow!"
        format.html { head :bad_request }
      end
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
