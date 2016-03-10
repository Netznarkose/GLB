class UserEntriesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    search_me = params[:search]
    unless search_me == nil || search_me == ""
      @user_entries = @user.entries.search(params[:search])
    else
      @user_entries = @user.entries.order(sort_column + " " + sort_direction).page(params[:page])
    end
  end
  private
  def sort_column
    Entry.column_names.include?(params[:sort]) ? params[:sort] : "kennzahl"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
