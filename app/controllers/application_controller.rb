class ApplicationController < ActionController::Base
  helper_method :sort_column, :sort_direction
  protect_from_forgery with: :exception
  protect_from_forgery except: :receive_guest
  layout :layout_by_resource
  before_action :set_paper_trail_whodunnit

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::AccessDenied do
    flash[:notice] = 'Zugriff verwehrt'
    redirect_to root_path
  end

  def record_not_found
    redirect_to root_path
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def sort_column
    (Entry.column_names + Entry::BEARBEITUNGS_STAND).include?(params[:sort]) ? params[:sort] : 'japanische_umschrift'
  end

  def sort_direction
    ['asc', 'desc'].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
