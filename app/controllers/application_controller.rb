class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :config_params_for_create, if: :devise_controller?
  before_action :config_params_for_edit, if: :devise_controller?

  def config_params_for_edit
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def config_params_for_create
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :password])
  end
end
