desc "sends email-notificattion if task expires"
task :email_notification => :environment do
  Task.all.each do |task|
    TaskNotifier.task_expired(task).deliver_now if task.expired?
  end
end
