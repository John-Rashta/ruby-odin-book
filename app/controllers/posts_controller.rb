class PostsController < ApplicationController
  before_action :set_own_post, only: %i[ update destroy ]
  def create
    @post = current_user.created_posts.build(post_params)
    if @post.save
      flash[:notice] = "Sucessfully created post!"
    else
      flash[:alert] = "Failed to create post!"
      head :bad_request
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Sucessfully deleted post!"
    else
      flash[:alert] = "Failed to delete post!"
      head :bad_request
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Sucessfully updated post!"
    else
      flash[:alert] = "Failed to update post!"
      head :bad_request
    end
  end

  private

  def set_own_post
    @post = current_user.created_posts.find(params[:id])
  end

  def post_params
    params.expect(post: [ :content ])
  end
end
