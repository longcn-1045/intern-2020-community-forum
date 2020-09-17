class Admin::ExcelsController < AdminController
  before_action :load_user_list, only: :index

  def index
    render xlsx: "users", template: "admin/users/index"
  end

  private

  def load_user_list
    @users = User.by_user_name(params[:name])
                 .by_status(params[:status])
                 .by_role(params[:role])
                 .order_by_post_count(params[:order_by])
                 .order_created_at
                 .page(params[:page]).per Settings.user.page
  end
end
