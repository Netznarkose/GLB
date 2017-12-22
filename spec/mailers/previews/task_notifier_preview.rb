# Preview all emails at http://localhost:3000/rails/mailers/task_notifier
class TaskNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_notifier/task_assigned
  def task_assigned
    TaskNotifier.task_assigned
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_notifier/task_done
  def task_done
    TaskNotifier.task_done
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_notifier/reminder
  def reminder
    TaskNotifier.reminder
  end

end
