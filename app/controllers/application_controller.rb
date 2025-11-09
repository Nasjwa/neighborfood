class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_attrs = [:first_name, :last_name, :address, :post_code, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_attrs)
  end
end
