class BadgerMail

  def self.get_user_overdue_tasks(user)
    @tasks = []
    
    user.tasks.each do |task|
      @tasks << task if task.over_due?
    end

    @tasks
  end

  def self.get_users_with_tasks

    @users = []
  
    User.all.each do |user|
      @users << user unless user.tasks.empty?
    end
    
    @users
  end

  def self.send_mail
    users = self.get_users_with_tasks
    users.each do |user|
      tasks = self.get_user_overdue_tasks(user)
      BadgerMailer.overdue_tasks_email(user, tasks).deliver_later
    end
  end
end