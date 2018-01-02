class Assignment < ActiveRecord::Base
  include AssignmentsHelper
  validates :creator_id, :recipient_id, :from_date, :to_date, presence: true
  before_save :update_user_id_in_entry

  def update_user_id_in_entry
    Entry.find(entry_id).update(user_id: recipient_id)
  end

  def expired?
    to_date < Date.today
  end
end
