class Admin::UsersController < AdminController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, except: :create

  def index
    @users = User.page(params[:page]).per Settings.user.per_page
  end

  def show; end

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
      redirect_to admin_login_path
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.success"
      redirect_to admin_users_path
    else
      flash[:danger] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.controller.delete"
      redirect_to admin_users_url
    else
      flash[:danger] = t "users.controller.delete_fail"
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def correct_user
    return if current_user? @user

    flash[:warning] = t "users.controller.not_correct"
    redirect_to admin_users_path
  end
end
