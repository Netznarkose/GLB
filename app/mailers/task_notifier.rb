class TaskNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_notifier.task_assigned.subject
  #
  def task_assigned(task)
    @task = task

    mail to: User.find(task.assigned_to_user).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_notifier.task_done.subject
  #
  def task_done(task)
    @task = task

    mail to: User.find(task.assigned_from_user).email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_notifier.reminder.subject
  #
  def reminder(mail_recipient)
    @greeting = "Hi"

    mail to: mail_recipient
  end
end
