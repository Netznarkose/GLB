class EntriesController < ApplicationController
  require './app/modules/export.rb'
  include Export
  load_and_authorize_resource
  before_action :build_entry_comment, only: :show
  helper_method :sort_column, :sort_direction

  def index
    if params[:search]
      @entries = Entry.search(params[:search]).page(params[:page])
      @count = Entry.search(params[:search]).count # refactoring needed
    else
      @entries = Entry.order(sort_column + " " + sort_direction).page(params[:page])
      @count = Entry.order(sort_column + " " + sort_direction).count # refactoring needed
    end
    respond_to do |format|
      format.html
      format.json { render json: all_entries }
      format.xml  { send_data all_entries.to_xml, :type => 'text/xml', :disposition => "attachment; filename=glb.xml" }
      format.text { send_data customized_xml, :type => 'text/xml', :disposition => "attachment; filename=customized_glb.xml" }
      format.csv  { send_data customized_csv, :type => 'text/csv', :disposition => "attachment; filename=glb.csv" }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @entry }
    end
  end

  def new
    @entry = Entry.new
  end

  def edit
  end

  def create
    @entry = Entry.new(entry_params)
    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Eintrag erfolgreich erstellt.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.update_attributes(entry_params)
        format.html { redirect_to @entry, notice: "Eintrag erfolgreich editiert. #{undo_link}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to user_entries_path(@entry.user), notice: "Eintrag erfolgreich gelöscht. #{undo_link}" }
      format.json { head :no_content }
    end
  end

  private

  def build_entry_comment
    if current_user
      @comment = Comment.new
      @comment.entry = @entry
      @comment.user = current_user
    end
  end

  def page
    params[:page] || 1
  end

  def entry_params
    params.require(:entry).permit(Entry::ALLOWED_PARAMS)
  end

  def undo_link
    view_context.link_to("Rückgängig", revert_version_path(@entry.versions.reload.last), :method => :post)
  end

  def record_not_found
    redirect_to entries_url
  end
  def sort_column
    Entry.column_names.include?(params[:sort]) ? params[:sort] : "japanische_umschrift"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
