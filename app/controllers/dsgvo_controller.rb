class DsgvoController < ApplicationController
  def welcome
    redirect_to entries_path if current_user
  end
end
