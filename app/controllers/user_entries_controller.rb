class UserEntriesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    unless params[:search].empty?
      @user_entries = @user.entries.search(params[:search])
    else
      @user_entries = @user.entries.all
    end
  end
end
