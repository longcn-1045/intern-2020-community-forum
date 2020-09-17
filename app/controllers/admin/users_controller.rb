class Admin::UsersController < AdminController
  before_action :logged_in_user, except: :show
  before_action :load_user, except: :index
  before_action :admin_user

  add_breadcrumb I18n.t("users.breadcrumbs.user"), :admin_users_path

  def index
    @users = User.by_user_name(params[:name])
                 .by_status(params[:status])
                 .by_role(params[:role])
                 .order_by_post_count(params[:order_by])
                 .order_created_at
                 .page(params[:page]).per Settings.user.page
  end

  def show
    add_breadcrumb I18n.t("users.breadcrumbs.show")
  end

  def edit
    add_breadcrumb I18n.t("posts.breadcrumbs.edit")
  end

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
end
