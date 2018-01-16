class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :find_current_entry, only: [:create, :edit, :destroy, :update]
  before_action :find_comment, only: [:edit, :destroy, :update]

  def edit
    render 'entries/show'
  end

  def create
    @comment = @entry.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to entry_path(@entry)
    else
      render 'entries/show'
    end
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to entry_path(@entry)
    else
      render 'entries/show'
    end
  end

  def destroy
    @comment.destroy
    redirect_to entry_path(@comment.entry)
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
end
