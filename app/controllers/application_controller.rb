class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery :except => :receive_guest
  helper_method :current_or_guest_user
  layout :layout_by_resource
  # before_filter :authenticate_user!
  # before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied!"
    redirect_to root_path
  end

  def current_user
    super || User.new(role: 'guest') #methoden auftruf der superklasse
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :email
  end

  def record_not_found
    redirect_to root_path
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def admin?
    current_user.admin?
  end

  def chief_editor?
    current_user.chief_editor?
  end
  
  def editor?
    current_user.editor?
  end

  def commentator?
    current_user.commentator?
  end

  def guest?
    current_user.guest?
  end

  def current_user?
    @user = User.find(params[:id])
    current_user.id == @user.id
  end

end
