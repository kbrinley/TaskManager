class Emailer < ActionMailer::Base
  
  #Removed. This has been replaced by forgot_password
   #def contact(recipient, subject, message, sent_at = Time.now)
   #   @subject = subject
   #   @recipients = recipient
   #   @from = 'no-reply@kanbanfordevelopers.com.com'
   #   @sent_on = sent_at
   #   @body["title"] = 'Password Reset Request'
   #   @body["email"] = 'no-reply@kanbanfordevelopers.com.com'
   #   @body["message"] = message
   #   @headers = {}
  #end
  
  def forgot_password(recipient, subject, link, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'no-reply@kanbanfordevelopers.com'
    @sent_on = sent_at
    @body["title"] = 'Password Reset Request'
    @body["link"] = link
    @headers = {}
  end
  
  def statistics()
    @subject = 'Statistics for ' + Time.now.strftime("%m/%d/%Y")
    @recipients = 'kevin@kanbanfordevelopers.com'
    @from = 'statistics@kanbanfordevelopers.com'
    @sent_on = Time.now
    @body["user_count"] = User.find(:all).length #Number of Users
    @body["task_count"] = Task.find(:all).length #Number of Tasks
    @body["goal_count"] = Goal.find(:all).length #Number of Goals
    @headers = {}
  end
end
