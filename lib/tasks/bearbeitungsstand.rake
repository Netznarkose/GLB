desc "Detects and labels Bearbeitungsstand of Entries"
task :set_entry_bearbeitungsstand => :environment do
  rake_task_user = User.new(name: 'rake-task', email: 'rake@user.com', role: 'admin', password: 'password', password_confirmation: 'password')
  rake_task_user.save unless User.find_by(email: rake_task_user.email)
  Entry.label_unprocessed
  Entry.label_formatted
  Entry.label_unformatted
end
