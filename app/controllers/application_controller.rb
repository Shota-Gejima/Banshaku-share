class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :admin_check, except: [:top,:about, :confirm]
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    recipes_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :birthday])
  end
  
  # 管理者か判定
  def admin_check
    admin_signed_in?
  end
end
