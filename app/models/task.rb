include ModelHelper

class Task < ActiveRecord::Base
  acts_as_reportable
  attr_accessible :description, :category_id, :goal_id, :itemcolor_id, :percentcomplete
  #before_create :verifyEOL # No longer needed as bug is fixed
  after_create { |record| Taskhistory.create!(:task_id => record.id, :user_id => record.user.id, :category_id => record.category_id) }
  #This is overkill, as changes to description would trigger this
  #after_save { |record| Taskhistory.create!(:task_id => record.id, :user_id => record.user.id, :category_id => record.category_id) }
  
  validates_presence_of :description, :category_id, :user_id
  
  validate :category_does_not_exceed_limit
    
  validates_length_of :percentcomplete, :maximum => 3, :allow_nil => true, :allow_blank => true
  validates_format_of :percentcomplete, :with => /^\d$/, :allow_nil => true, :allow_blank => true
  
  belongs_to :user
  belongs_to :category
  belongs_to :goal
  has_many :taskhistories
  belongs_to :itemcolor
  
  default_scope :order => 'category_id asc'
  
  def category_does_not_exceed_limit
    # A size of 0 or less denotes an infinite size (such as the completed queue)
    if (self.category.size > 0)
      if (self.category.task.exists?(self.id))
        errors.add(:category_id, "can't exceed size limit") if
          self.category.task.count > self.category.size
      else
        errors.add(:category_id, "can't exceed size limit") if
          (self.category.task.count + 1) > self.category.size
      end
    end
  end
  
  def escaped_description
    #return self.description.gsub(/[']/, "\\\\'").gsub(/["]/, "\\\\\"").gsub(//n/, )
    return escape_javascript(self.description)
  end
  
  def report_record
    #[:description, :category_label, :created_date, :last_updated_date]
    record = {}
    record[:description] = self.description
    record[:category_label] = self.category.label
    record[:created_date] = self.created_at
    record[:last_updated_date] = self.updated_at
    record[:percentcomplete] = self.percentcomplete
    
    return record
  end
  
  private
  # Comes from:
  # File actionpack/lib/action_view/helpers/javascript_helper.rb
  def escape_javascript(javascript)
    (javascript || '').gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
  end
end
