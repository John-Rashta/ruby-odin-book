class PostsController < ApplicationController
  before_action :set_own_post, only: %i[ update destroy ]
  before_action :validate_params, only: %i[ update create ]

  # FEED
  def index
    @posts = Post.eager_load(:creator).where(creator_id: [ current_user.id ].concat(current_user.followings.ids))
  end

  def show
    @post = Post.eager_load(:creator, direct_comments: :creator).find(params[:id])
  end
  def create
    @post = current_user.created_posts.build(postable: ContentCreation.new.create_content(post_params))
    if @post.postable.valid? && @post.save && @post.postable.save
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
    ContentCreation.new.create_or_update_content(@post, post_params)
    if @post.save && @post.postable.save
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
    if params.has_key?(:post) && params[:post].has_key?(:image)
      params.expect(post: [ :image ])
    elsif params.has_key?(:post) && params[:post].has_key?(:content)
      params.expect(post: [ :content ])
    end
  end

  def validate_params
    params = post_params
    validation = helpers.validate_params(params)
    unless validation[:valid]
      flash[:alert] = validation[:message]
      head 400
    end
  end
end
