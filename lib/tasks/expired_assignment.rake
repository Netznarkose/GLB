namespace :db do
  desc "sends email-notificattion, resets entry.user_id and deletes assignment if assignment expired"
  task :expired_assignment => :environment do

    def send_email_notification(assignment)
      AssignmentNotifier.expired(assignment).deliver_now
    end
    def set_entry_user_id_to_assignment_creator_id(assignment)
      Entry.find(assignment.entry_id).update(user_id: assignment.creator_id)
    end

    def delete_assignment(assignment)
      assignment.destroy
    end
    Assignment.all.each do |assignment|
      if assignment.expired?
        send_email_notification(assignment)
        set_entry_user_id_to_assignment_creator_id(assignment)
        delete_assignment(assignment)
      end
    end
  end
end
