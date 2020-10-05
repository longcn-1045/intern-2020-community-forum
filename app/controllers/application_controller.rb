class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  include PublicActivity::StoreController
  include SessionsHelper

  before_action :set_locale, :load_right_sidebar

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def load_right_sidebar
    @post_sidebar = Post.includes(:user)
                        .order_created_at
                        .on
                        .first Settings.right_bar.new_feeds
    @topics_sidebar = Topic.all
    @celebrities_sidebar = User.all_except(current_user)
                               .order_followers_count
                               .first Settings.right_bar.celebrities
    load_activities_sidebar
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}.merge(super)
  end

  def load_activities_sidebar
    return if current_user.blank?

    @activities_sidebar = current_user.activities
                                      .includes(:trackable)
                                      .order_created_at
                                      .limit Settings.acts.per_page_sidebar
  end
end
