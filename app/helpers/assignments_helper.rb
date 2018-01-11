module AssignmentsHelper
  def entry
    Entry.find(entry_id)
  end

  def name_of_recipient
    User.find(recipient_id).name
  end

  def email_of_recipient
    User.find(recipient_id).email
  end

  def name_of_creator
    User.find(creator_id).name
  end

  def email_of_creator
    User.find(creator_id).email
  end

  def deadline
    Date.today + two_third_of_processing_time
  end
end
