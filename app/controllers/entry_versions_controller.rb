class EntryVersionsController < ApplicationController
  def index
    @entry_versions_container = []
    find_current_entry
    @entry_version = @entry.versions.size
    entry_versions_count = @entry.versions.size
    if entry_versions_count > 1
      1.upto(entry_versions_count) do |count_me|
        @entry_versions_container << @entry.versions[- count_me]
      end
    end
  end
  def show
    find_current_entry_version
    # @entry = Entry.find(params[:entry_id])
    # @entry_version  = @entry.entry_versions.find(params[:id])
  end

  def find_current_entry
    binding.pry
    @entry = Entry.find(params[:entry_id])
  end
  def find_current_entry_version
    binding.pry
    @entry = Entry.find(params[:entry_id][:id])
    @entry_version  = @entry.entry.versions.find_by(params[:id])
  end
end
