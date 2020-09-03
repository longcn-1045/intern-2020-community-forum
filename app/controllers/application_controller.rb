class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_locale

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def record_activity(content)
    activity = Log.new
    activity.user = current_user
    activity.content = content
    activity.browser = request.env['HTTP_USER_AGENT']
    activity.ip_address = request.env['REMOTE_ADDR']
    activity.controller = controller_name
    activity.action = action_name
    activity.save
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}.merge(super)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_login"
    redirect_to login_url
  end
end
