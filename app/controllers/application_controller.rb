class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_locale, :load_right_sidebar

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def load_right_sidebar
    @post_sidebar = Post.includes(:user).order_created_at.last Settings.right_bar.new_feeds
    @topics_sidebar = Topic.all
  end

  def check_pending_post

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
