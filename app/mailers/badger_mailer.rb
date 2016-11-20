class BadgerMailer < ApplicationMailer
  default from: 'kirk@zuuzlo.com'

  def overdue_tasks_email(user, tasks)
    @user = user
    @tasks = tasks
    mail(to: @user.email, subject: 'You have overdue tasks')
  end
end
