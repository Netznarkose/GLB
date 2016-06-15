class EntryVersionsController < ApplicationController
  before_action :find_current_entry, only: [:index, :show]

  def index
    @entry_versions_all = []
    if @entry.versions.size > 1
      1.upto(@entry.versions.size) do |count_me|
        if @entry.versions[- count_me].event == 'update'
          @entry_versions_all << @entry.versions[- count_me]
        end
      end
    end
  end

  def show
    @version_number = params[:id].to_i
    entry_papertrail_version = @entry.versions[- @version_number]
    @entry_created_at = entry_papertrail_version.created_at
    @entry_papertrail_version_reified = entry_papertrail_version.reify
  end

  private

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end
end
