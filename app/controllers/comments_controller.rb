#encoding: utf-8
class CommentsController < ApplicationController
  before_action :find_comment, only: [:edit, :update, :destroy]

  def edit
    @entry = @comment.entry
    # if @comment.user != current_user && current_user.role != "admin"
    #   flash[:notice] = 'Access denied!'
      redirect_to entry_path(@comment.entry)
    # end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @entry = @comment.entry # is necessary for the rendering of 'entries/show'
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
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to entry_path(@comment.entry) + "#comments", notice: 'Kommentar erfolgreich bearbeitet.' }
        format.json { head :no_content }
      else
        raise
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry = @comment.entry
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to entry_path(@comment.entry), notice: 'Kommentar erfolgreich gelöscht.'}
      format.json { head :no_content }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment,:user_id,:entry_id)
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end
end
