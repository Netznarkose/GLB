#encoding: utf-8
class CommentsController < ApplicationController
  # before_action :find_comment, only: [:edit, :update, :destroy]
  before_action :find_current_entry, only: [:create, :edit, :destroy, :update]

  def edit
    @entry = Entry.find(params[:entry_id])
    @comment = @entry.comments.find(params[:id])
    render 'entries/show'
  end

  def create
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to entry_path(@comment.entry) } 
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render 'entries/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
      @comment = @entry.comments.find(params[:id])
      if @comment.update_attributes(comment_params)
        redirect_to edit_entry_comment_path(@entry, @comment)
        # format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render 'entries/show' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end

    # respond_to do |format|
    #   if @comment.update_attributes(comment_params)
    #     format.html { redirect_to entry_path(@comment.entry), notice: 'Kommentar erfolgreich bearbeitet.' }
    #     format.json { head :no_content }
    #   else
    #     raise
    #     format.html { render action: "edit" }
    #     format.json { render json: @comment.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def destroy
      @entry = Entry.find(params[:entry_id])
      @comment = @entry.comments.find(params[:id])

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to entry_path(@comment.entry), notice: 'Kommentar erfolgreich gelöscht.'}
      format.json { head :no_content }
    end
  end

  private
    def find_current_entry 
      @entry = Entry.find(params[:entry_id])
    end

    def comment_params
      params.require(:comment).permit(:comment, :user_id, :entry_id)
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end
end
