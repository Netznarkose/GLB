class Assignment < ActiveRecord::Base
  include AssignmentsHelper
  validates :entry_id, :creator_id, :recipient_id, :from_date, :to_date, presence: true
  validates :entry_id, uniqueness: true
  before_save :update_user_id_in_entry

  def update_user_id_in_entry
    Entry.find(entry_id).update(user_id: recipient_id)
  end

  def expired?
    to_date < Date.today
  end

  def remindable?
    days_expired_since_assignment > two_third_of_processing_time
  end

  def two_third_of_processing_time
    ((2.0/3.0) * (to_date - from_date).to_i).round
  end

  def days_expired_since_assignment
    ((Date.today - from_date).to_i).round
  end
end
