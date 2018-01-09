namespace :db do
  desc 'sends email-reminder, for assignments older then 2/3 of lifetime'
  task reminder_assignment: :environment do
    Assignment.all.each do |assignment|
      if assignment.remindable?
        AssignmentNotifier.reminder(assignment).deliver_now
      end
    end
  end
end
