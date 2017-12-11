class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new(assigned_from_user: current_user.id, assigned_entry: params['entry_id'])
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to user_entries_path(@task.assigned_to_user), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to user_entries_path(@task.assigned_to_user), notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    task_assignee = @task.assigned_to_user
    @task.destroy
    redirect_to user_entries_path(task_assignee), notice: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:assigned_from_user, :assigned_to_user, :assigned_at_date, :assigned_to_date, :assigned_entry)
  end
end
