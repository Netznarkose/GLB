class AssignmentNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_assigned.subject
  #
  def create(assignment)
    @assignment = assignment

    mail to: User.find(assignment.recipient_id).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_done.subject
  #
  def done(assignment)
    @assignment = assignment

    mail to: User.find(assignment.creator_id).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.reminder.subject
  #
  def expired_creator(assignment)
    @assignment = assignment

    mail to: User.find(assignment.creator_id).email
  end

  def expired_recipient(assignment)
    @assignment = assignment

    mail to: User.find(assignment.recipient_id).email
  end
end
