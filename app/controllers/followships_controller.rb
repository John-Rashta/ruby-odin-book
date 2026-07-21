class FollowshipsController < ApplicationController
  include Pagy::Method
  # MIGHT REQUIRE TESTING PAGY
  protect_from_forgery with: :exception
  def index
    @pagy, @follows = pagy(:countless, current_user.followings.eager_load(:followed, :follow_request_by_current).order(id: :desc), limit: 15)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def followers
    @pagy, @followers = pagy(:countless, current_user.followers.eager_load(:followed, :follow_request_by_current).order(id: :desc), limit: 15)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  def destroy
    this_params = destroy_params
    @followship = current_user.inverse_followships.find_by(user_id: this_params[:user_id])
    respond_to do |format|
      if @followship && @followship.destroy
        flash.now[:notice] = "Sucessfull Unfollow!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to unfollow!"
        format.html { head :bad_request }
        # REMOVE USER FROM FOLLOWSHIPS PAGE IF FAILED TO UNFOLLOW AND UPDATE FORM
        if other_user = User.find_by(id: this_params[:user_id])
          format.turbo_stream {
            render :followship_failure, locals: { current_user: current_user, user: other_user }, status: :unprocessable_entity
          }
        end
      end
    end
  end

  def create
    this_params = create_params
    @request = current_user.requests.includes(:sender).find_by(id: this_params[:id])

    @followship = current_user.followships.includes(:sender).create_or_find_by(follower_id: @request&.sender_id)
    respond_to do |format|
      if @request && @request.destroy && @followship.previously_new_record?
        flash.now[:notice] = "Accepted Follow!"
        format.turbo_stream
        format.html { head :ok }
        RequestsBroadcastJob.perform_later(
          current_user,
          helpers.get_other_user_from_request(current_user, @request),
          { action: "destroy", requestId: @request.id }
        )
      else
        @followship.destroy
        flash[:alert] = "Failed to accept follow!"
        format.html { head :bad_request }
        # IF FAILED DELETE THE REQUEST FROM REQUESTS PAGE IF IT EXISTS
        format.turbo_stream { render turbo_stream: turbo_stream.remove("request-#{this_params[:id]}"), status: :unprocessable_entity }
      end
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
