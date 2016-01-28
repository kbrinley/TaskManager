include ModelHelper
# <summary>
# Reperesents a Goal in the system, a unit of work that the user aims to complete in the 
# allotted time frame.
# </summary>
class Goal < ActiveRecord::Base
  acts_as_reportable
  ##before_create :verifyEOL # No longer needed as bug is fixed
  attr_accessible :description, :goaltype_id, :datecompleted, :completed_flag, :percentcomplete
  
  belongs_to :user
  belongs_to :goaltype
  
  validates_length_of :percentcomplete, :maximum => 3, :allow_nil => true, :allow_blank => true
  validates_format_of :percentcomplete, :with => /^\d$/, :allow_nil => true, :allow_blank => true
  
  # <summary>
  # Creates a Hash object and returns it containing information to be used by the Goal reports.
  # </summary>
  def report_record
    record = {}
    record[:description] = self.description
    record[:goaltype_label] = self.goaltype.label
    record[:datecompleted] = self.datecompleted unless self.datecompleted.nil?
    record[:created_date] = self.created_at
    record[:last_updated_date] = self.updated_at
    record[:percentcomplete] = self.percentcomplete
    
    return record
  end

  def escaped_description
    #return self.description.gsub(/[']/, "\\\\'").gsub(/["]/, "\\\\\"").gsub(//n/, )
    return escape_javascript(self.description)
  end
  
  private
  # Comes from:
  # File actionpack/lib/action_view/helpers/javascript_helper.rb
  def escape_javascript(javascript)
    (javascript || '').gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
  end
  
end
