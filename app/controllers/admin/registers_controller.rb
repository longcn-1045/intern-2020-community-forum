class Admin::RegistersController < Devise::RegistrationsController
  layout "authenticate"

  before_action :configure_sign_up_params, only: :create

  def create
    super
  end

  private

  def after_sign_up_path_for _resource
    new_user_session_path
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit :sign_up, keys: User::PERMIT_ATTRIBUTES
  end
end
