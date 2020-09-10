class Admin::DashboardController < AdminController
  before_action :logged_in_user, :admin_user

  def index
    @posts = Post.order_updated_at
    @users = User.order_created_at
  end
end
