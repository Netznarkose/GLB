class UserEntriesController < ApplicationController
  helper_method :entry_owner?
  before_action :find_user, only: :index

  def index
    @user_entries = params[:search] ? paginate_entries(search_user_entries) : paginate_entries(sort_user_entries)
    @count = @user_entries.count
  end

  private

  def paginate_entries(entries)
    Kaminari.paginate_array(entries).page(params[:page])
  end

  def search_user_entries
    @user.entries.search(params[:field_select], params[:search])
  end

  def sort_user_entries
    if Entry::BEARBEITUNGS_STAND.include?(sort_column)
      @user.entries.where(bearbeitungsstand: sort_column).order(japanische_umschrift: sort_direction)
    else
      @user.entries.order(sort_column + ' ' + sort_direction)
    end
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def entry_owner?
    current_user.id == @user.id
  end
end
