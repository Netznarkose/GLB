class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: %i[edit update destroy]

  def new
    @task = Task.new(assigned_from_user: current_user.id, assigned_entry: params['entry_id'])
  end

  def edit
  end

  def create
    @task = Task.new(task_params.merge({assigned_to_date: calc_expiry_date}))
    if @task.save
      redirect_to user_entries_path(@task.assigned_to_user), notice: 'Task was successfully created.'
      TaskNotifier.task_assigned(@task).deliver_now
    else
      render :new
    end
  end

  def update
    if @task.update(task_params.merge({assigned_to_date: calc_expiry_date}))
      redirect_to user_entries_path(@task.assigned_to_user), notice: 'Task was successfully updated.'
      TaskNotifier.task_assigned(@task).deliver_now
    else
      render :edit
    end
  end

  def destroy
    task_assignee = @task.assigned_to_user
    if @task.destroy
      redirect_to user_entries_path(task_assignee), notice: 'Task was successfully destroyed.'
      TaskNotifier.task_done(@task).deliver_now
    end
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

  def calc_expiry_date
    Date.today + (task_params[:assigned_to_date].to_i).month
  end

end
