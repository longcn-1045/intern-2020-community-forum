module SessionsHelper
  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def check_remember user
    if params[:session][:remember_me].eql? Settings.user.validates.checkbox
      remember user
    else
      forget user
    end
  end

  def admin_user
    return if current_user.role != Settings.user.role

    flash[:alert] = t "users.controller.not_allow"
    redirect_to root_path
  end

  def current_user? user
    user && user == current_user
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def correct_user
    return if current_user? @user

    flash[:alert] = t "users.controller.not_correct"
    redirect_to admin_users_path
  end
end
