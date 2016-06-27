class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery :except => :receive_guest
  layout :layout_by_resource

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied!"
    redirect_to root_path
  end

  def current_user
    super || User.new(role: 'guest') #methoden auftruf der superklasse
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

  def editor?
    current_user.editor?
  end

  def author?
    current_user.author?
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
