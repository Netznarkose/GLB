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
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end





  protected

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", :role => 'guest')
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
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

  def current_user?
    @user = User.find(params[:id])
    current_user.id == @user.id
  end

end
