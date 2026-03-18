class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(get_search_columns)
    if @like.save
      flash[:notice] = "Sucessfully Liked!"
    else
      flash[:alert] = "Failed to Like!"
      head :bad_request
    end
  end

  def destroy
    @like = current_user.likes.find_by!(get_search_columns)
    if @like.destroy
      flash[:notice] = "Sucessfully Removed Like!"
    else
       flash[:alert] = "Failed to Destroy!"
      head :bad_request
    end
  end

  private

  def get_search_columns
    {
      contentable_id: params.include?(:post_id) ? params[:post_id] : params[:comment_id],
      contentable_type: params.include?(:post_id) ? "Post" : "Comment"
    }
  end
end
