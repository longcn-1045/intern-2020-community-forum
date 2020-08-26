class Admin::RegistersController < AdminController
  layout "authenticate"

  def index
    @user = User.new
  end
end
