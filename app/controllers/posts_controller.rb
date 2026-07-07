class PostsController < ApplicationController
  include Pagy::Method
  before_action :set_own_post, only: %i[ update destroy edit part ]
  before_action :validate_params, only: %i[ update create ]
  protect_from_forgery with: :exception

  # FEED
  def index
    @pagy, @posts = pagy(:countless, Post.eager_load(:creator).order(created_at: :desc).where(creator_id: [ current_user.id ].concat(current_user.followings.ids)), limit: 15)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @post = Post.eager_load(:creator, direct_comments: :creator).find(params[:id])

    @pagy, @direct_comments = pagy(:countless, @post.direct_comments, limit: 15)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def part
  end

  def edit
  end
  def create
    @post = current_user.created_posts.build(postable: ContentCreation.new.create_content(post_params))
    respond_to do |format|
      if @post.postable.valid? && @post.save && @post.postable.save
        flash[:notice] = "Sucessfully created post!"
        format.turbo_stream
        format.html { head :ok }
        PostCreationJob.perform_later(@post)
      else
        flash[:alert] = "Failed to create post!"
        format.html { head :bad_request }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @post.destroy
        flash[:notice] = "Sucessfully deleted post!"
        format.turbo_stream
        format.html { head :ok }
      else
        flash[:alert] = "Failed to delete post!"
        format.html { head :bad_request }
      end
    end
  end

  def update
    # BROADCAST UPDATE HERE AND SEND TO A JOB
    ContentCreation.new.update_or_replace_content(@post, post_params)
    respond_to do |format|
      if @post.save && @post.postable.save
        flash[:notice] = "Sucessfully updated post!"
        format.turbo_stream
        format.html { head :ok }
        PostUpdateJob.perform_later(@post.id, "content", @post)
      else
        flash[:alert] = "Failed to update post!"
        format.html { head :bad_request }
      end
    end
  end

  private

  def set_own_post
    @post = current_user.created_posts.includes(:creator).find(params[:id])
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
