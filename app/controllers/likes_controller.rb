class LikesController < ApplicationController
  protect_from_forgery with: :exception
  def create
    params = get_search_columns
    @like = current_user.likes.includes(:contentable).create_or_find_by(params)
    respond_to do  |format|
      if @like.previously_new_record?
        flash.now[:notice] = "Sucessfully Liked!"
        format.turbo_stream
        format.html { head :ok }
        if @like.contentable_type == "Post"
          PostUpdateJob.perform_later(@like.contentable_id, "likes_count", @like.contentable.likes_count)
        else
          CommentUpdateJob.perform_later(@like.contentable_id, "likes_count", @like.contentable.likes_count)
        end
      else
        flash[:alert] = "Failed to Like!"
        if content = params[:contentable_type].constantize.find_by(id: params[:contentable_id])
          format.turbo_stream { render :update_form, locals: { type: params[:contentable_type].downcase, content_id: params[:contentable_id], content: content }, status: :unprocessable_entity }
        end
        format.html { head :bad_request }
      end
    end
  end

  def destroy
    params = get_search_columns
    @like = current_user.likes.includes(:contentable).find_by(params)
    respond_to do  |format|
      if @like && @like.destroy
        flash.now[:notice] = "Sucessfully Removed Like!"
        format.turbo_stream
        format.html { head :ok }
        if @like.contentable_type == "Post"
          PostUpdateJob.perform_later(@like.contentable_id, "likes_count", @like.contentable.likes_count)
        else
          CommentUpdateJob.perform_later(@like.contentable_id, "likes_count", @like.contentable.likes_count)
        end
      else
        flash[:alert] = "Failed to Destroy!"

        if content = params[:contentable_type].constantize.find_by(id: params[:contentable_id])
          format.turbo_stream { render :update_form, locals: { type: params[:contentable_type].downcase, content_id: params[:contentable_id], content: content }, status: :unprocessable_entity }
        end
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
