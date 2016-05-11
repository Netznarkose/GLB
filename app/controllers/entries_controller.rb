class EntriesController < ApplicationController
  load_and_authorize_resource
  before_action :find_entry, only: [:show, :update, :destroy]
  before_action :protect_from_editors_who_try_to_update_an_entry_for_somebodyelse, only: :update
  before_action :protect_from_editors_who_try_to_create_an_entry_for_somebodyelse, only: :create
  before_action :protect_from_editors_who_try_to_delete_an_entry_of_somebodyelse, only: :destroy
  before_action :protect_from_commentators_and_guests_who_try_to_read_unpublished_entries, only: :show

  helper_method :sort_column, :sort_direction

  # uncomment sḱip_before_filter to make entries visible; (preferably in connection with published filter)
  #skip_before_filter :authenticate_user!, only: [:index, :show]
  # GET /entries
  # GET /entries.json
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

  # GET /entries/1
  # GET /entries/1.json
  def show
    # binding.pry
    build_entry_comment
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    # if current_user.role == "admin"
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @entry }
      end
    # else
    #   flash[:notice] = 'Sie dürfen keine neuen Einträge erstellen.'
    #   redirect_to :action => 'index'
    # end
  end

  # GET /entries/1/edit
  def edit
    # if @entry.user != current_user && current_user.role != "admin"
    #   flash[:notice] = "Sie dürfen die Einträge von anderen Mitarbeitern nicht bearbeiten. Hinterlassen Sie stattdessen einen Kommentar."
    #   redirect_to :action => 'show'
    # end
  end

  # POST /entries
  # POST /entries.json
  def create
    # ???
    # params[:entry].delete("freigeschaltet")
    # @entry.user = current_user unless @entry.user_id.present?
    
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

  # PUT /entries/1
  # PUT /entries/1.json
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


  def find_entry
    @entry = Entry.find(params[:id])
  end

  def protect_from_editors_who_try_to_update_an_entry_for_somebodyelse
    if current_or_guest_user.editor? && params[:entry][:user_id].to_i != current_or_guest_user.id 
      redirect_to @entry, notice: 'as editor you are not allowed to edit somebody else\'s entry'
    end
  end
  def protect_from_editors_who_try_to_create_an_entry_for_somebodyelse
    if current_or_guest_user.editor? && @entry.user_id != current_or_guest_user.id #when user is an editor and creates an entry for somebody else
      redirect_to new_entry_path, notice: 'as editor you are not allowed to create an entry for somebody else'
    end
  end

  def protect_from_editors_who_try_to_delete_an_entry_of_somebodyelse
    if current_or_guest_user.editor? && @entry.user_id != current_or_guest_user.id #when user is an editor and creates an entry for somebody else
      redirect_to @entry, notice: 'as editor you are not allowed to delete somebody else\'s entry'
    end
  end

  def protect_from_commentators_and_guests_who_try_to_read_unpublished_entries
    if current_or_guest_user.commentator? && @entry.freigeschaltet == false || current_or_guest_user.guest? && @entry.freigeschaltet == false
      redirect_to entries_path, notice: 'commentators and guests are not allowed to read unpublished entries'
    end
  end

  def build_entry_comment
    if current_or_guest_user
      @comment = Comment.new
      @comment.entry = @entry
      @comment.user = current_or_guest_user
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
