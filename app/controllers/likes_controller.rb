class LikesController < ApplicationController
  protect_from_forgery with: :exception
  def create
    @like = current_user.likes.includes(:contentable).build(get_search_columns)
    respond_to do  |format|
      if @like.save
        flash.now[:notice] = "Sucessfully Liked!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to Like!"
        format.html { head :bad_request }
      end
    end
  end

  def destroy
    @like = current_user.likes.includes(:contentable).find_by!(get_search_columns)
    respond_to do  |format|
      if @like.destroy
        flash.now[:notice] = "Sucessfully Removed Like!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to Destroy!"
        format.html { head :bad_request }
      end
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
