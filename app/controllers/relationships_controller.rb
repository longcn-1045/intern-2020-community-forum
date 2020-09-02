class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: %i(create destroy)

  def create
    if @user.present?
      if current_user.following? @user
        @error = t ".followed user"
      else
        current_user.follow @user
      end
    end

    respond_to :js
  end

  def destroy
    if @user.present?
      if current_user.following? @user
        current_user.unfollow @user
      else
        @error = t ".unfollowed user"
      end
    end

    respond_to :js
  end

  private

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    @error = t ".not_found"
  end
end
