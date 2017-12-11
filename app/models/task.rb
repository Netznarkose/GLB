class Task < ActiveRecord::Base
  validates :assigned_from_user, :assigned_to_user, :assigned_at_date, :assigned_to_date, presence: true

  def entry
    Entry.find(assigned_entry)
  end
end
