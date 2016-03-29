#encoding: utf-8
class CommentsController < ApplicationController

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])
    redirect_to entry_path(@comment.entry) + "#comments"
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @entry = @comment.entry
    if @comment.user != current_user && current_user.role != "admin"
      flash[:notice] = 'Access denied!'
      redirect_to entry_path(@comment.entry) + "#comments"
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to entry_path(@comment.entry) } 
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to entry_path(@comment.entry) + "#comments", notice: 'Kommentar erfolgreich bearbeitet.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @entry = @comment.entry
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @entry, notice: 'Kommentar erfolgreich gelöscht.'}
      format.json { head :no_content }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment,:user_id,:entry_id)
    end
end
