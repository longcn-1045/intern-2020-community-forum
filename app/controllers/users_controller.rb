class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: %i(edit update show)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.by_user_name(params[:name])
                 .sort_type(params[:select_type])
                 .by_follow_status(params[:status], current_user)
                 .all_except(current_user)
                 .page(params[:page])
                 .per Settings.topics.per_page
  end

  def show
    @posts = @user.posts
                  .includes(:topic, :tags)
                  .order_created_at
                  .by_title(params[:name])
                  .by_topic_id(params[:select_type])
                  .by_status params[:status]
  end

  def edit; end

  def update
    if @user.update_without_password user_params
      flash[:notice] = t ".profile_updated"
      redirect_to @user
    else
      flash.now[:alert] = t ".failed_update_profile"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:alert] = t ".not_found"
    redirect_to root_url
  end
end
