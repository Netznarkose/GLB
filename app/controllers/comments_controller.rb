class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :find_current_entry, only: [:create, :edit, :destroy, :update]
  before_action :find_comment, only: [:edit, :destroy, :update]
  before_action :protect_from_users_who_try_to_update_somebody_elses_comment, only: :update
  before_action :protect_from_editors_commentators_and_guests_who_try_to_delete_somebody_elses_comment, only: :destroy

  def edit
    @renders_edit_comment_partial = true
    render 'entries/show'
  end

  def create
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to entry_path(@entry), notice: 'Kommentar erfolgreich erstellt.' }
        format.json { render :show, status: :created, location: @comment } # ????
      else
        flash[:notice] = 'Kommentar konnte nicht erstellt werden.'
        format.html { render 'entries/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to entry_path(@entry), notice: 'Kommentar erfolgreich bearbeitet.' }
        format.json { head :no_content }      
      else
        format.html { render 'entries/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to entry_path(@comment.entry), notice: 'Kommentar erfolgreich gelöscht.' }
      format.json { head :no_content }
    end
  end

  private

  def find_current_entry
    @entry = Entry.find(params[:entry_id])
  end

  def find_comment
    @comment = @entry.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :user_id, :entry_id)
  end

  def protect_from_users_who_try_to_update_somebody_elses_comment
    if @comment.user_id != current_user.id
      redirect_to @entry, notice: 'you are not allowed to update somebody else\s comment'
    end
  end
  def protect_from_editors_commentators_and_guests_who_try_to_delete_somebody_elses_comment
    if current_user.editor? && @comment.user_id != current_user.id
      redirect_to @entry, notice: 'editors are not allowed to update somebody else\s comment'
    elsif current_user.commentator? && @comment.user_id != current_user.id
      redirect_to @entry, notice: 'commentators are not allowed to update somebody else\s comment'
    end
  end
end
