desc "sends email-notificattion if task expires"
task :email_notification => :environment do
  Assignment.all.each do |assignment|
    AssignmentNotifier.expired(assignment).deliver_now if assignment.expired?
  end
end
