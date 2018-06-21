class AssignmentNotifier < ApplicationMailer
  def create(assignment)
    @assignment = assignment
    subject = I18n.t('assignment_notifier.create.subject', japanische_umschrift: assignment.entry.japanische_umschrift, kennzahl: assignment.entry.kennzahl)

    mail to: User.find(assignment.recipient_id).email, subject: subject
  end

  def done(assignment)
    @assignment = assignment
    subject = I18n.t('assignment_notifier.done.subject', japanische_umschrift: assignment.entry.japanische_umschrift, kennzahl: assignment.entry.kennzahl)

    mail to: User.find(assignment.creator_id).email, subject: subject
  end

  def reminder(assignment)
    @assignment = assignment
    subject = I18n.t('assignment_notifier.reminder.subject', japanische_umschrift: assignment.entry.japanische_umschrift, kennzahl: assignment.entry.kennzahl)

    mail to: User.find(assignment.recipient_id).email, subject: subject
  end

  def expired(assignment)
    @assignment = assignment
    subject = I18n.t('assignment_notifier.expired.subject', japanische_umschrift: assignment.entry.japanische_umschrift, kennzahl: assignment.entry.kennzahl)

    mail to: User.find(assignment.recipient_id).email, subject: subject
    mail cc: User.find(assignment.creator_id).email, subject: subject
  end
end
