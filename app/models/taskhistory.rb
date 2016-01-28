# <summary>
# A TaskHistory is created when a Task is updated. It records the category_id of the task at that
# time, as well as the date the update occurred.
# </summary>
class Taskhistory < ActiveRecord::Base
  acts_as_reportable
  attr_accessible :task_id, :category_id, :created_at
  
  validates_presence_of :task_id, :category_id
  
  belongs_to :task
  belongs_to :category
  #belongs_to :user, :through => :task
  
  # <summary>
  # Creates a Hash object, then returns it for use in the Historical Task report.
  # </summary>
  def report_record
    record = {}
    record[:task_id] = self.task_id
    record[:task_description] = self.task.description unless self.task == nil
    record[:category_label] = self.category.label unless self.category == nil
    record[:date] = self.created_at
    
    return record
  end
end