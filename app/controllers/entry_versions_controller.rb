class EntryVersionsController < ApplicationController
  before_action :find_current_entry, only: [:index, :show]
  before_action :find_current_version, only: :show

  helper_method :version_number

  def index
    @versions = @entry.versions.filter_versions_without_objects.reverse_order
  end

  def show
    @version = @unreified_version.reify
  end

  def version_number
    version_params[:version_number]
  end

  private

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end

  def find_current_version
    @unreified_version = @entry.versions.find(version_params[:id])
  end

  def version_params
    params.permit(:id, :version_number)
  end
end
