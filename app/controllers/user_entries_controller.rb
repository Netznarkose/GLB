class UserEntriesController < ApplicationController
  helper_method :entry_owner?
  before_action :find_user, only: :index

  def index
    @user_entries = params[:search] ? search_user_entries : sort_user_entries
    @count = @user_entries.count
  end

  private

  def search_user_entries
    @user.entries.search(params[:search]).page
  end

  def sort_user_entries
    @user.entries.order(sort_column + ' ' + sort_direction).page
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def entry_owner?
    current_user.id == @user.id
  end
end
