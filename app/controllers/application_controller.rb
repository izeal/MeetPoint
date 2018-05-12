class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :config_params_for_create, if: :devise_controller?
  before_action :config_params_for_edit, if: :devise_controller?

  helper_method :current_user_can_edit?
  helper_method :user_owner_of?
  helper_method :user_subscribed?

  def config_params_for_edit
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def config_params_for_create
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :password])
  end

  def current_user_can_edit?(model)
    user_signed_in? && (
      model.user == current_user || (
        model.try(:event) && model.event.user == current_user
      )
    )
  end

  def user_owner_of?(model)
    model.user == current_user
  end

  def user_subscribed?(event)
    return unless current_user
    event.subscriptions.find_by(user_id: current_user.id)
  end

  def participants_emails(event)
    (event.subscriptions.preload(:user).map(&:user_email) + [event.user.email] - [current_user.try(:email)]).uniq
  end
end
