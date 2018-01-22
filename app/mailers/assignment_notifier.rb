class AssignmentNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_assigned.subject
  #
  def create(assignment)
    @assignment = assignment
    subject = "Zuweisung des Eintrags #{assignment.entry.japanische_umschrift} (#{assignment.entry.kennzahl})"

    mail to: User.find(assignment.recipient_id).email, subject: subject
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.assignment_done.subject
  #
  def done(assignment)
    @assignment = assignment
    subject = "Eintrag #{assignment.entry.japanische_umschrift} (#{assignment.entry.kennzahl}) erledigt"

    mail to: User.find(assignment.creator_id).email, subject: subject
  end

  def reminder(assignment)
    @assignment = assignment
    subject = "Überschreitung des Bearbeitungszeitraums für Eintrag #{assignment.entry.japanische_umschrift} (#{assignment.entry.kennzahl})"

    mail to: User.find(assignment.recipient_id).email, subject: subject
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assignment_notifier.reminder.subject
  #
  def expired(assignment)
    @assignment = assignment
    subject = "Rücknahme des Bearbeitungsrechts für Eintrag #{assignment.entry.japanische_umschrift} (#{assignment.entry.kennzahl})"

    mail to: User.find(assignment.recipient_id).email, subject: subject
    mail cc: User.find(assignment.creator_id).email, subject: subject
  end
end
