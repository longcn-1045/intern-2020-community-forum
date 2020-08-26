class Admin::UsersController < AdminController
  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "users.controller.signup_success"
      redirect_to admin_root_path
    else
      flash.now[:danger] = t "users.controller.inform_failed"
      render :new
    end
  end

  def edit; end

  def update; end

  def delete; end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "users.controller.cautious_login"
    redirect_to admin_login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.controller.not_found"
    redirect_to admin_root_path
  end
end
