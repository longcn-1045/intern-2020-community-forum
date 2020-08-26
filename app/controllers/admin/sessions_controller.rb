class Admin::SessionsController < AdminController
  layout "authenticate"

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      check_remember user
      redirect_back_or user
    else
      flash.now[:danger] = t "sessions.controller.inform_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to admin_login_url
  end
end
