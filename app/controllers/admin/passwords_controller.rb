class Admin::PasswordsController < Devise::PasswordsController
  layout "authenticate"

  skip_authorization_check

  private

  def after_resetting_password_path_for _resource
    root_path
  end
end
