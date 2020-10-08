class Admin::BlockController < AdminController
  before_action :load_user, :admin_user

  def update
    BlockWorker.perform_async @user.id
    if @user.active?
      @user.block!
    else
      @user.active!
    end
    flash[:notice] = t "users.update.success"
    redirect_to admin_users_path
  end

  def authorize
    UserRoleWorker.perform_async @user.id
    if @user.member?
      @user.admin!
    else
      @user.member!
    end
    flash[:notice] = t "users.update.success"
    redirect_to admin_users_path
  end
end
