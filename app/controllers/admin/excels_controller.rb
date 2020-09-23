class Admin::ExcelsController < AdminController
  before_action :load_users_filter

  def index
    render xlsx: "users", template: "admin/users/index"
  end

  private

  def load_users_filter
    @users = User.user_ids session[:user_filtered]
  end
end
