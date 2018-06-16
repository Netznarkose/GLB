class EntriesController < ApplicationController
  include Export
  load_and_authorize_resource
  before_action :build_entry_comment, only: :show

  def index
    @count = (params[:search] ? search_entries : sort_entries).count
    @entries = params[:search] ? paginate_entries(search_entries) : paginate_entries(sort_entries)

    respond_to do |format|
      format.html
      format.json { render json: all_entries }
      format.xml  { send_data all_entries.to_xml, type: 'text/xml', disposition: 'attachment; filename=glb.xml' }
      format.text { send_data customized_xml(all_entries), type: 'text/xml', disposition: 'attachment; filename=customized_glb.xml' }
      format.csv  { send_data customized_csv(all_entries), type: 'text/csv', disposition: 'attachment; filename=glb.csv' }
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
    flash.now[:notice] = "In Bearbeitung von #{@entry.assignment.name_of_recipient} zum #{@entry.assignment.to_date}" if @entry.assignment
  end

  def create
    @entry = Entry.new(entry_params)
    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Eintrag erfolgreich erstellt.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: 'new' }
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
        format.html { render action: 'edit' }
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

  def paginate_entries(entries)
    Kaminari.paginate_array(entries).page(params[:page])
  end


  def build_entry_comment
    if current_user
      @comment = Comment.new
      @comment.entry = @entry
      @comment.user = current_user
    end
  end

  def all_entries
    @all_entries ||= Entry.all
  end

  def entry_params
    params.require(:entry).permit(Entry::ALLOWED_PARAMS)
  end

  def undo_link
    view_context.link_to('Rückgängig', revert_version_path(@entry.versions.reload.last), method: :post)
  end

  def record_not_found
    redirect_to entries_url
  end

  def search_entries
    Entry.search(params[:field_select], params[:search])
  end

  def sort_entries
    if Entry::STATUS.include?(sort_column)
      Entry.where(status: sort_column).order(japanische_umschrift: sort_direction)
    else
      Entry.order(sort_column + ' ' + sort_direction)
    end
  end
end
