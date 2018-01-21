class EntryVersionsController < ApplicationController
  before_action :find_current_entry, only: [:index, :show]
  before_action :find_current_version, only: [:show, :created_at, :version_author]

  helper_method :created_at, :version_author, :version_number

  def index
    @versions = @entry.versions.filter_versions_without_objects.reverse_order
  end

  def show
    @version = @unreified_version.reify
  end

  def created_at
    @unreified_version.created_at
  end

  def version_author
    @unreified_version.user_name
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
