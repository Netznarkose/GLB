# Preview all emails at http://localhost:3000/rails/mailers/assignment_notifier
class AssignmentNotifierPreview < ActionMailer::Preview
  @assignment = FactoryBot.create(:assignment)

  # Preview this email at http://localhost:3000/rails/mailers/assignment_notifier/create
  def create
    AssignmentNotifier.create(@assignment)
  end

  # Preview this email at http://localhost:3000/rails/mailers/assignment_notifier/done
  def done
    AssignmentNotifier.done
  end

  # Preview this email at http://localhost:3000/rails/mailers/assignment_notifier/expired
  def expired
    AssignmentNotifier.expired
  end

end
