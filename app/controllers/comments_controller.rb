class CommentsController < ApplicationController
  include Pagy::Method
  # MAYBE ALREADY INTRODUCE NOT HAVING POST AND CHECKING IF COMMENT ID IS PASSED? NOT SURE
  # USE NESTING INSTEAD- EITHER DOUBLE NESTING ON SINGLE- COMMENTS NESTED IN POSTS IN COMMENTS OR SEPARATE-
  # COMMENTS NESTED IN POSTS AND ALSO COMMENTS NESTED IN COMMENTS- DO IT SEPARATE- USE NAMESPACES OR SOMETHING
  # PROBABLY CHANGE NAMES CAUSE COMMENTS/ID/COMMENTS LOOKS BAD
  # CHECK IF COMMENT ID IS PRESENT AND GRAB THAT AND ITS ID AND POSTID OTHERWISE BUILD DIRECT COMMENT TO POST ID
  before_action :set_own_comment_or_return, only: %i[ update edit ]
  protect_from_forgery with: :exception

  def show
    @comment = Comment.eager_load(:creator, comments: :creator).order("comments_comments.created_at": :desc).find(params[:id])
    @pagy, @comments = pagy(:countless, @comment.comments, limit: 15)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit
  end

  def part
    @comment = current_user.created_comments.eager_load(:creator).find(params[:id])
  end

  # METHOD JUST FOR FETCHING COMMENTS FOR COMMENTS BELLOW COMMENTS
  def comments_part
    @depth = part_depth_params.to_i
    @first = part_filter_params
    @comment = Comment.eager_load(:creator, comments: :creator).find(params[:id])
    @pagy, @comments = pagy(:countless, @comment.comments, limit: 5)
    respond_to do |format|
      format.turbo_stream
    end
  end
  def create
    create_params =
      if params.include?(:post_id)
        { post_id: params[:post_id], **comment_params }
      else
        parent = Comment.find(params[:comment_id])
        { post_id: parent[:post_id], comment_id: parent[:id], **comment_params }
      end

    @comment = current_user.created_comments.build(create_params)
    respond_to do |format|
      if @comment.save
        flash[:notice] = "Sucessfully created Comment"
        format.turbo_stream
        format.html { head :ok }
        PostUpdateJob.perform_later(@comment.post_id, "comments_count", @comment.post.comments_count)
        if @comment.comment
          CommentUpdateJob.perform_later(@comment.comment_id, "comments_count", @comment.comment.comments_count)
          if @comment.comment.comments_count == 1
            CommentCreationJob.perform_later(@comment, get_depth_params_or_default, true)
            return
          end
        end
        CommentCreationJob.perform_later(@comment, get_depth_params_or_default)
      else
        flash[:alert] = "Failed to create Comment"
        format.html { head :bad_request }
      end
    end
  end

  def destroy
    @comment = current_user.created_comments.includes(:post, :comment, :creator).find_by(id: params[:id])
    respond_to do |format|
      if @comment && @comment.destroy
        flash[:notice] = "Sucessfully deleted comment!"
        format.turbo_stream
        format.html { head :ok }
        PostUpdateJob.perform_later(@comment.post_id, "comments_count", @comment.post.comments_count)
        if @comment.comment
          CommentUpdateJob.perform_later(@comment.comment_id, "comments_count", @comment.comment.comments_count)
          if @comment.comment.comments_count == 0
            CommentDestructionJob.perform_later(@comment.comment_id)
          end
        end
      else
        flash[:alert] = "Failed to delete comment!"
        format.html { head :bad_request }
        format.turbo_stream { render :failed_find, locals: { comment_id: params[:id] }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash[:notice] = "Sucessfully updated comment!"
        format.turbo_stream
        format.html { head :ok }
        CommentUpdateJob.perform_later(@comment.id, "content", @comment.content)
      else
        flash[:alert] = "Failed to update comment!"
        format.html { head :bad_request }
      end
    end
  end

  private

  def get_depth_params_or_default
    if params.include?(:depth) && params[:depth].to_i.between?(1, 10)
      params[:depth].to_i
    else
      1
    end
  end

  def set_own_comment_or_return
    @comment = current_user.created_comments.find_by(id: params[:id])
    unless @comment
      respond_to do |format|
        format.html { head :not_found }
        format.turbo_stream { render :failed_find, locals: { comment_id: params[:id] }, status: :unprocessable_entity }
      end
    end
  end

  def part_filter_params
    if params.include?(:first) && params[:first] == "true"
      return "true"
    end

    "false"
  end

  def part_depth_params
    params.expect(:depth)
  end

  def comment_params
    params.expect(comment: [ :content ])
  end
end
