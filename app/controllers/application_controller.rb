class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def get_raw_connection
    conn = ActiveRecord::Base.connection
    conn
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:user) {|u| u.permit(:name, :email, :password, :username, :password_confirmation)}
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :username, :password_confirmation)}
  end
end
