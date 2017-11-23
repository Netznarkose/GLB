require 'pry-byebug'
desc "Detects and labels Bearbeitungsstand of Entries"
task :set_entry_bearbeitungsstand => :environment do
  rake_task = User.new(name: 'rake-task', email: 'rake@user.com', role: 'admin', password: 'password', password_confirmation: 'password')
  rake_task.save unless User.find_by(email: rake_task.email)
  Entry.all.each do |entry|
    entry.update(bearbeitungsstand: 'unbearbeitet', user_id: rake_task.id) if entry.unprocessed?
    # entry.bearbeitungsstand = 'unformatiert' if entry.unformated?
    # entry.bearbeitungsstand = 'formatiert' if entry.formated?
  end
end
