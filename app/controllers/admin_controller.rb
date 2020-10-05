class AdminController < ActionController::Base
  layout "admin"

  include SessionsHelper
  include NotificationsHelper

  before_action :set_locale
  before_action :load_notify

  add_breadcrumb I18n.t("dashboard.breadcrumbs.home"), :admin_root_path

  helper_method :get_all_notification, :get_uncheck_notification

  private

  def get_uncheck_notification
    @number = Notification.uncheck.count
  end

  def get_all_notification
    @notifications.order_created_at.take Settings.notifications.page
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    parsed_locale if I18n.available_locales.map(&:to_s).include? parsed_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.controller.not_found"
    redirect_to admin_root_path
  end

  def load_notify
    @notifications = Notification.includes :user, :post
  end
end
