class EntryVersionsController < ApplicationController
  before_action :find_current_entry, only: [:index, :show]

  def index
    @versions = @entry.versions.all
  end

  def show
    @version = @entry.versions.find(params[:id]).reify
  end

  private

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end

  # def version_params
  #   params.require(:version).permit(:version_id)
  # end
end
