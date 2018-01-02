class AssignmentNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_assigned.subject
  #
  def create(assignment)
    @assignment = assignment

    mail to: User.find(assignment.assigned_to_user).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_done.subject
  #
  def done(assignment)
    @assignment = assignment

    mail to: User.find(assignment.assigned_from_user).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.reminder.subject
  #
  def expired(assignment)
    @assignment = assignment

    mail to: User.find(assignment.assigned_from_user).email
  end
end
