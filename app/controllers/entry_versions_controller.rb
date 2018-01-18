class EntryVersionsController < ApplicationController
  before_action :find_current_entry, only: [:index, :show]

  def index
    @versions = @entry.versions.reverse_order
  end

  def show
    @version_number = params[:version_number]
    fetch_version = @entry.versions.find(params[:id])
    @created_at = fetch_version.created_at
    @version_author = fetch_version.user_name
    @version = fetch_version.reify
  end

  private

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end

  # def version_params
  #   params.require(:version).permit(:version_id)
  # end
end
