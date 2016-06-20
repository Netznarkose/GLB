class EntriesController < ApplicationController
  load_and_authorize_resource
  before_action :build_entry_comment, only: :show
  # before_action :protect_from_editors_who_try_to_update_an_entry_for_somebodyelse, only: :update
  before_action :protect_from_editors_who_try_to_delete_an_entry_of_somebodyelse, only: :destroy

  helper_method :sort_column, :sort_direction

  # uncomment sḱip_before_filter to make entries visible; (preferably in connection with published filter)
  #skip_before_filter :authenticate_user!, only: [:index, :show]
  def index
    if params[:search]
      @entries = Entry.search(params[:search]).page(params[:page])
    else
      @entries = Entry.order(sort_column + " " + sort_direction).page(params[:page])
    end
    @count = @entries.count
    respond_to do |format|
      format.html # index.html.erb
      format.csv {send_data @entries.to_csv, :type => 'text/csv', :disposition => "attachment; filename=glb.csv"}
      format.xml {send_data @entries.to_xml, :type => 'text/xml', :disposition => "attachment; filename=glb.xml"}
      format.json { render json: @entries }
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
    respond_to do |format|
      format.html 
      format.json { render json: @entry }
    end
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
    binding.pry
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

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Eintrag erfolgreich gelöscht. #{undo_link}" }
      format.json { head :no_content }
    end
  end

  private

  def protect_from_editors_who_try_to_update_an_entry_for_somebodyelse
    if current_user.editor? && params[:entry][:user_id].to_i != current_user.id 
      redirect_to @entry, notice: 'as editor you are not allowed to edit somebody else\'s entry'
    end
  end

  def protect_from_editors_who_try_to_delete_an_entry_of_somebodyelse
    if current_user.editor? && @entry.user_id != current_user.id #when user is an editor and creates an entry for somebody else
      redirect_to @entry, notice: 'as editor you are not allowed to delete somebody else\'s entry'
    end
  end

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
    Entry.column_names.include?(params[:sort]) ? params[:sort] : "kennzahl"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
