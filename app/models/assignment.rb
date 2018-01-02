class Assignment < ActiveRecord::Base
  include AssignmentsHelper
  validates :assigned_from_user, :assigned_to_user, :assigned_at_date, :assigned_to_date, presence: true
  before_save :update_user_id_in_entry

  def update_user_id_in_entry
    Entry.find(assigned_entry).update(user_id: assigned_to_user)
  end

  def expired?
    assigned_to_date < Date.today
  end
end
