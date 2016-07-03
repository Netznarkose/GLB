class UserEntriesController < ApplicationController
  before_action :find_user, only: :index
  def index
    if search_item = params[:search]
      @user_entries = @user.entries.search(search_item).page(params[:page])
    else
      @user_entries = @user.entries.order(sort_column + ' ' + sort_direction).page(params[:page])
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def sort_column
    Entry.column_names.include?(params[:sort]) ? params[:sort] : 'kennzahl'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
