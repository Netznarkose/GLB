#encoding: utf-8
class EntriesController < ApplicationController

  load_and_authorize_resource
  # uncomment sḱip_before_filter to make entries visible; (preferably in connection with published filter)
  #skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :entry, only: [:show]
  before_filter :selected_entries, only: [:index]
  # GET /entries
  # GET /entries.json
  def index
    @count = @selected_entries.count
    # @entries = @selected_entries.page(params[:page])
    @entries = Entry.order(params[:sort]) # sorting does not work with search @selected_entries

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
    if current_user.role == "admin"
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @entry }
      end
    else
      flash[:notice] = 'Sie dürfen keine neuen Einträge erstellen.'
      redirect_to :action => 'index'
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user != current_user && current_user.role != "admin"
      flash[:notice] = "Sie dürfen die Einträge von anderen Mitarbeitern nicht bearbeiten. Hinterlassen Sie stattdessen einen Kommentar."
      redirect_to :action => 'show'
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    params[:entry].delete("freigeschaltet")
    @entry = Entry.new(entry_params)
    @entry.user = current_user unless @entry.user_id.present?

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
    @entry = Entry.find(params[:id])
    if current_user.role == 'admin'
      @verfasser = User.find(params[:entry].delete('user_id'))
      @entry.user = @verfasser
    end

    respond_to do |format|
      if @entry.update_attributes(entry_params)
        format.html { redirect_to @entry, notice: "Eintrag erfolgreich gespeichert. #{undo_link}" }
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
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Eintrag erfolgreich gelöscht. #{undo_link}" }
      format.json { head :no_content }
    end
  end

  private

  def entry
    # published filter does not apply to any entries yet
    #@entry = Entry.published.find(params[:id])
    @entry = Entry.find(params[:id])
  end

  def selected_entries
    params[:search] = nil if params[:search] and params[:search].strip == ""
    @selected_entries = (params[:search] ? Entry.search(params[:search]) : Entry).order("romaji_order")
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

end
