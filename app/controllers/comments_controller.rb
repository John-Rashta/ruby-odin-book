class CommentsController < ApplicationController
  # MAYBE ALREADY INTRODUCE NOT HAVING POST AND CHECKING IF COMMENT ID IS PASSED? NOT SURE
  # USE NESTING INSTEAD- EITHER DOUBLE NESTING ON SINGLE- COMMENTS NESTED IN POSTS IN COMMENTS OR SEPARATE-
  # COMMENTS NESTED IN POSTS AND ALSO COMMENTS NESTED IN COMMENTS- DO IT SEPARATE- USE NAMESPACES OR SOMETHING
  # PROBABLY CHANGE NAMES CAUSE COMMENTS/ID/COMMENTS LOOKS BAD
  # CHECK IF COMMENT ID IS PRESENT AND GRAB THAT AND ITS ID AND POSTID OTHERWISE BUILD DIRECT COMMENT TO POST ID
  before_action :set_own_comment, only: %i[ update destroy ]

  def show
    @comment = Comment.eager_load(:creator, comments: :creator).find(params[:id])
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
    if @comment.save
      flash[:notice] = "Sucessfully created Comment"
    else
      flash[:alert] = "Failed to create Comment"
      head :bad_request
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = "Sucessfully deleted comment!"
    else
      flash[:alert] = "Failed to delete comment!"
      head :bad_request
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Sucessfully updated comment!"
    else
      flash[:alert] = "Failed to update comment!"
      head :bad_request
    end
  end

   private

  def set_own_comment
    @comment = current_user.created_comments.find(params[:id])
  end

  def comment_params
    params.expect(comment: [ :content ])
  end
end
