class Admin::SessionsController < Devise::SessionsController
  layout "authenticate"

  skip_authorization_check

  private

  def after_sign_in_path_for resource
    if resource.is_a?(User) && resource.admin?
      admin_root_path
    else
      static_pages_home_path
    end
  end

  def after_sign_out_path_for _resource
    new_user_session_path
  end
end
