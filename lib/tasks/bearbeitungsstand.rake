namespace :db do
  desc "labels Bearbeitungsstand of Entries"
  task :label_bearbeitungsstand => :environment do
    rake_task_user = User.new(name: 'rake-task', email: 'rake@user.com', role: 'admin', password: 'password', password_confirmation: 'password')
    rake_task_user.save unless User.find_by(email: rake_task_user.email)
    Entry.label_bearbeitungsstand
  end
end
