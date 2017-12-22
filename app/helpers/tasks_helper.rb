module TasksHelper
  def entry
    Entry.find(assigned_entry)
  end

  def name_of_assigned_user
    User.find(assigned_to_user).name
  end

  def name_of_task_creator
    User.find(assigned_from_user).name
  end

  def email_of_assigned_user
    User.find(assigned_to_user).email
  end
end
