class UsersController < ApplicationController
  def index
    @users = User.eager_load(:followed, :follow_request_by_current).where.not(id: current_user.id).all
  end
  def show
    @user = User.eager_load(created_posts: :creator).find(params[:id])
  end
end
