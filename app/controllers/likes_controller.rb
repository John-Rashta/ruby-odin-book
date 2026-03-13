class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(contentable_id: params[:post_id], contentable_type: "Post")
    if @like.save
      flash[:notice] = "Sucessfully Liked!"
    else
      flash[:alert] = "Failed to Like!"
      head :bad_request
    end
  end

  def destroy
    @like = current_user.likes.find_by!(contentable_id: params[:post_id], contentable_type: "Post")
    if @like.destroy
      flash[:notice] = "Sucessfully Removed Like!"
    else
       flash[:alert] = "Failed to Destroy!"
      head :bad_request
    end
  end
end
