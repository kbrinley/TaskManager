require 'digest'

# <summary>
# The User object contains the login info, as well as links to nearly every other table in the 
# application.
# </summary>
class User < ActiveRecord::Base
  acts_as_reportable

 before_create { |record|
    record.accountexpiration = Time.now + 120.days
    record.premiumaccount = true
    record.percentcompleteenabled = true
    record.name = ''
 }

  # <summary>
  # When a user is created, these 6 categories are automatically created.
  # </summary>
  after_create { |record| 
    record.category.create!(:label => "Completed", :listorder => 0, :size => 0) 
    record.category.create!(:label => "Backlog", :listorder => 1, :size => 9) 
    record.category.create!(:label => "In Progress", :listorder => 2, :size => 4) 
    record.category.create!(:label => "On Hold", :listorder => 3, :size => 9) 
    record.category.create!(:label => "Ready to Deliver", :listorder => 4, :size => 9)
    record.category.create!(:label => "Delivered", :listorder => 5, :size => 9)
    
    record.itemcolors.create!(:label => "Yellow", :listorder => 1, :color => "#f5e848")
    record.itemcolors.create!(:label => "Orange", :listorder => 2, :color => "#888888")
    record.itemcolors.create!(:label => "Green", :listorder => 3, :color => "#00FF00")
    record.itemcolors.create!(:label => "Blue", :listorder => 4, :color => "#0000FF")
  }
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :reset_code, :accountexpiration, :percentcompleteenabled
  
  has_many :tasks
  has_many :goals
  has_many :category
  has_many :itemcolors
  has_many :taskhistories, :through => :tasks
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  
  validates_presence_of :email
  #validates_length_of :name, :maximum => 50
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  
  #automatically creates the virtual attribute :password_confirmation
  validates_confirmation_of :password
  
  #Password validation
  validates_presence_of :password
  validates_length_of :password, :within => 6..40
  
  before_save :encrypt_password
  
  # <summary>
  # Validates password entered for logging in.
  # </summary>
  def has_password?(submitted_password)
    #will test if the submitted_password is the same as the encrypted password
    encrypted_password == encrypt(submitted_password)
  end
  
  def account_expired?
    if accountexpiration.nil?
      false
    else
      accountexpiration <= Time.now
    end
  end
  
  def account_expire_soon?
    if accountexpiration.nil?
      false
    else
      accountexpiration <= 1.month.from_now
    end
  end
  
  # <summary>
  # Generates the Remember_Me token for the user.
  # </summary>
  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    save_without_validation
  end
  
  # <summary>
  # Verifies that the user is valid and that the correct password was supplied.
  # </summary>
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    #return nil if user.account_expired?
    return user if user.has_password?(submitted_password)
  end
  
  # <summary>
  # Generates a reset code and is designed to email it to the user.
  # </summary>
  def create_reset_code!
    #@reset = true
    self.reset_code = secure_hash( Time.now.to_s.split(//).sort_by {rand}.join )
    save(false)
    #self.save()
  end 
  
  # <summary>
  # Generates the reset_code for the user.
  # </summary>
  def generate_reset_code
    return secure_hash( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  # <summary>
  # Determines if the user recently requested a password reset.
  # </summary>
  def recently_reset?
    @reset
  end 
  
  # <summary>
  # Deletes the reset code (such as, after it has been used successfully.
  # </summary>
  def delete_reset_code
    self.reset_code = nil
    save(false)
  end
  
  # <summary>
  # Returns a hash object for the Administrative User report.
  # </summary>
  def report_record
    record = {}
    record[:id] = self.id
    record[:email] = self.email
    record[:name] = self.name
    record[:premiumaccount] = self.premiumaccount
    record[:adminaccount] = self.adminaccount
    record[:passwordresetflag] = ! self.reset_code.nil?
    
    return record
  end
  
  # <summary>
  # Returns a Hash object which contains all of the values for the reports fields. 
  # </summary>
  def statistical_report_record
    completedcategoryid = self.category.find(:all, :conditions => [
      "listorder = 0"
    ])[0].id
    lastweekstasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.week.ago}'"])
    lastmonthstasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.month.ago}'"])
    lastyearstasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.year.ago}'"])  
    lastweekscompletedtasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.week.ago}' AND category_id = '#{completedcategoryid}'"])
    lastmonthscompletedtasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.month.ago}' AND category_id = '#{completedcategoryid}'"])
    lastyearscompletedtasks = self.tasks.find(:all, :conditions =>
      ["created_at > '#{1.year.ago}' AND category_id = '#{completedcategoryid}'"])
     
    completedgoals = self.goals.find(:all, :conditions =>
      ["datecompleted is not null"])
      
    wtdgoals = self.goals.find(:all, :conditions =>
      ["created_at > '#{1.week.ago}'"])
    mtdgoals = self.goals.find(:all, :conditions =>
      ["created_at > '#{1.month.ago}'"])
    ytdgoals = self.goals.find(:all, :conditions =>
      ["created_at > '#{1.year.ago}'"])
    
      
    if self.goals.count == 0
      goalcompletionrate = 0
    else
      goalcompletionrate = 100 - (((self.goals.count - count_goals_on_time(self.goals) + 0.0) / self.goals.count) * 100)
    end
    
    if (wtdgoals.count == 0)
      wtdgoalcompletionrate = 0
    else
      wtdgoalcompletionrate = 100 - (((wtdgoals.count - count_goals_on_time(wtdgoals) + 0.0) / wtdgoals.count) * 100)  
    end
    
    if (mtdgoals.count == 0)
      mtdgoalcompletionrate = 0
    else
      mtdgoalcompletionrate = 100 - (((mtdgoals.count - count_goals_on_time(mtdgoals) + 0.0) / mtdgoals.count) * 100)  
    end
    
    if (ytdgoals.count == 0)
      ytdgoalcompletionrate = 0
    else
      ytdgoalcompletionrate = 100 - (((ytdgoals.count - count_goals_on_time(ytdgoals) + 0.0) / ytdgoals.count) * 100)  
    end
    
      
    sum_fix_time = 0
    sum_days_open = 0
      
    lastyearscompletedtasks.each do |t|
      sum_fix_time = (t.updated_at - t.created_at + 0.0).round / 60.0
      sum_days_open = (t.updated_at - t.created_at + 0.0).round / (60 * 60 * 24)
    end
      
    record = {}
    record[:avg_time_to_fix] = ((sum_fix_time / lastyearscompletedtasks.count) / 60.0).round(2) unless lastyearscompletedtasks.count == 0
    record[:avg_days_open] = sum_days_open / lastyearscompletedtasks.count unless lastyearscompletedtasks.count == 0

    record[:new_tasks_last_week] = lastweekstasks.count
    record[:new_tasks_last_month]  = lastmonthstasks.count
    record[:new_tasks_last_year] = lastyearstasks.count
    record[:completed_tasks_last_week] = lastweekscompletedtasks.count
    record[:completed_tasks_last_month] = lastmonthscompletedtasks.count
    record[:completed_tasks_last_year] = lastyearscompletedtasks.count
    record[:task_back_log_increase] = lastweekstasks.count - lastweekscompletedtasks.count
    
    record[:num_of_rejected_defects] = 10
    record[:percent_rejected_defects] = 11
    record[:velocity] = 12
    record[:wtd_goal_completion_rate] = wtdgoalcompletionrate
    record[:mtd_goal_completion_rate] = mtdgoalcompletionrate
    record[:ytd_goal_completion_rate] = ytdgoalcompletionrate
    record[:goal_completion_rate] = goalcompletionrate
    
    return record
  end
  
  private
  
  def encrypt_password
    unless password.nil?
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
  end
  
  def encrypt(string)
    secure_hash("#{salt}#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def count_goals_on_time(goalsdata)
    goalsontime = 0 
      
    goalsdata.each do |g|
      if (g.datecompleted != nil)
        if g.goaltype_id == 1
          # Check if goal was completed within 24 hours of creation
          if ((g.datecompleted - g.created_at) < (60 * 60 * 24))
            goalsontime += 1
          end
        elsif g.goaltype_id == 2
          # Check if goal was completed within 7 days of creation
          if ((g.datecompleted - g.created_at) < (60 * 60 * 24 * 7))
            goalsontime += 1
          end
        elsif g.goaltype_id == 3
          # Check if goal was completed within 30 days of completion
          if (g.datecompleted - g.created_at < 60 * 60 * 24 * 30)
            goalsontime += 1
          end
        end
      end
    end
    return goalsontime
  end
end
