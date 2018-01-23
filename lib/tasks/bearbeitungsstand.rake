namespace :db do
  desc "labels Bearbeitungsstand of Entries"
  task label_bearbeitungsstand: :environment do
    Entry.label_bearbeitungsstand
  end
end
