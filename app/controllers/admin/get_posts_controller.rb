class Admin::GetPostsController < AdminController
  before_action :get_user

  def index
    @posts = @user.posts.order_updated_at
    respond_to :js
  end

  private

  def get_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t "users.controller.not_found"
    redirect_to admin_root_path
  end
end
