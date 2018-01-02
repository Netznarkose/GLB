class AssignmentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_assignment, only: %i[edit update destroy]

  def new
    @assignment = Assignment.new(assigned_from_user: current_user.id, assigned_entry: params['entry_id'])
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params.merge({assigned_to_date: calc_expiry_date}))
    if @assignment.save
      redirect_to user_entries_path(@assignment.assigned_to_user), notice: 'Assignment was successfully created.'
      AssignmentNotifier.create(@assignment).deliver_now
    else
      render :new
    end
  end

  def update
    if @assignment.update(assignment_params.merge({assigned_to_date: calc_expiry_date}))
      redirect_to user_entries_path(@assignment.assigned_to_user), notice: 'Task was successfully updated.'
      AssignmentNotifier.create(@assignment).deliver_now
    else
      render :edit
    end
  end

  def destroy
    assignment_recipient = @assignment.assigned_to_user
    if @assignment.destroy
      redirect_to user_entries_path(assignment_recipient), notice: 'Task was successfully destroyed.'
      AssignmentNotifier.done(@assignment).deliver_now
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def assignment_params
    params.require(:assignment).permit(:assigned_from_user, :assigned_to_user, :assigned_at_date, :assigned_to_date, :assigned_entry)
  end

  def calc_expiry_date
    Date.today + (assignment_params[:assigned_to_date].to_i).month
  end

end
