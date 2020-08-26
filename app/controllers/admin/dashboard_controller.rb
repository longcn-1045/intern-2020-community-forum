class Admin::DashboardController < AdminController
  before_action :logged_in_user

  def index; end
end
