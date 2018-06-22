class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :birthday, :email, :password, :remember_me)}
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :birthday, :email, :password, :current_password, :remember_me)}
    end

  private

    def logged_in_user
      unless user_signed_in?
        flash[:danger] = 'Por favor, inicia sesión'
        redirect_to new_user_session_path
      end
    end
end
