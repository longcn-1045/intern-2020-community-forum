class Admin::BlockController < AdminController
  before_action :load_user, :admin_user

  def update
    if @user.active?
      BlockMailer.block_email(@user).deliver
      @user.block!
    else
      BlockMailer.unblock_email(@user).deliver
      @user.active!
    end
    flash[:notice] = t "users.update.success"
    redirect_to admin_users_path
  end

  def authorize
    if @user.member?
      AuthorizeMailer.admin_email(@user).deliver
      @user.admin!
    else
      AuthorizeMailer.member_email(@user).deliver
      @user.member!
    end
    flash[:notice] = t "users.update.success"
    redirect_to admin_users_path
  end
end
