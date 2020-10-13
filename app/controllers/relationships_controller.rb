class RelationshipsController < ApplicationController
  authorize_resource

  before_action :authenticate_user!
  before_action :find_user, only: %i(create destroy)

  def create
    current_user.follow @user
    check_follow_user

    respond_to :js
  end

  def destroy
    current_user.unfollow @user
    check_unfollow_user

    respond_to :js
  end

  private

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    @error = t ".not_found"
  end

  def check_follow_user
    @error = t ".unfollowed" unless current_user.following? @user
  end

  def check_unfollow_user
    @error = t ".followed" if current_user.following? @user
  end
end
