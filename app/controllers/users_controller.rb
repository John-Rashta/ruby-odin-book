class UsersController < ApplicationController
  include Pagy::Method
  protect_from_forgery with: :exception
  before_action :validate_image, only: %i[ change_avatar ]
  def index
    @pagy, @users = pagy(:countless,  User.eager_load(:followed, :follow_request_by_current).where.not(id: current_user.id).all, limit: 15)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  def show
    @user = User.eager_load(:followed, :follow_request_by_current).find(params[:id])

    @pagy, @posts = pagy(:countless, @user.created_posts.preload(:creator, liked: :user, postable: [ image_attachment: { blob: { variant_records: { image_attachment: :blob } } }, rich_text_content: { embeds_attachments: { blob: { variant_records: :blob } } } ]).order(posts: :desc), limit: 15)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def follow_request
    @user = User.eager_load(:followed, :follow_request_by_current).find(params[:id])
  end

  def change_avatar
    avatar_prep = helpers.create_avatar(user_params[:avatar])
    # use the alpha from the svg as the alpha for our image
    avatar_prep[:image].bandjoin(avatar_prep[:mask][3]).write_to_file("tmp/#{current_user.id}.png")
    current_user.avatar.attach(io: File.open("tmp/#{current_user.id}.png"), filename: "#{current_user.id}.png", content_type: "image/png")
    if current_user.save
      File.delete("tmp/#{current_user.id}.png")
      flash[:notice]= "Sucessfully changed avatar!"
    else
      flash[:alert] = "Failed to change avatar."
      head :bad_request
    end
  end

  private
  def user_params
    params.expect(user: [ :avatar ])
  end

  def validate_image
    unless helpers.validate_image?(user_params[:avatar])
      flash[:alert] = "Incorrect image type or image size."
      head 400
    end
  end
end
