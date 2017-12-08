class Task < ActiveRecord::Base
  def entry
    Entry.find(self.assigned_entry)
  end
end
