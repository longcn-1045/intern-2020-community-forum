class Admin::RegistersController < AdminController
  layout "authenticate"

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:info] = t "users.controller.signup_success"
      redirect_to admin_root_path
    else
      flash.now[:danger] = t "users.controller.signup_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end
end
