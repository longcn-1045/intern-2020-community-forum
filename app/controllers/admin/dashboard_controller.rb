class Admin::DashboardController < AdminController
  before_action :logged_in_user, :admin_user

  def index
    @posts = Post.order_updated_at.includes(:user)
                 .take(Settings.user.validates.time)
    @users = User.order_created_at
    @on_posts = Post.on.count
    @off_posts = Post.off.count
    @pending_posts = Post.pending.count
  end
end
