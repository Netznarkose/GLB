module AssignmentsHelper
  def entry
    Entry.find(assigned_entry)
  end

  def name_of_recipient
    User.find(assigned_to_user).name
  end

  def email_of_recipient
    User.find(assigned_to_user).email
  end

  def name_of_creator
    User.find(assigned_from_user).name
  end

  def email_of_creator
    User.find(assigned_from_user).email
  end
end
