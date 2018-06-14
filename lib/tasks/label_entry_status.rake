namespace :db do
  desc "labels status of entries"
  task label_entry_status: :environment do
    Entry.label_status
  end
end
