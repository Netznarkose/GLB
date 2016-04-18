class EntryVersionsController < ApplicationController
  def index
    @entry_versions_all = []
    find_current_entry
    if @entry.versions.size > 1
      1.upto(@entry.versions.size) do |count_me|
        @entry_versions_all << @entry.versions[- count_me]
      end
    end
  end
  def show
    @entry = Entry.find(params[:entry_id])
    version_number = params[:id].to_i
    @entry_version  = @entry.versions[- version_number]
    binding.pry
  end

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end
  def find_current_entry2
    @entry = PaperTrail::Version.find(params[:item_id])
  end
  def find_current_entry_version
    binding.pry
    @entry = Entry.find(params[:entry_id])
    @entry_version  = @entry.entry.versions.find_by(params[:id])
  end
end
