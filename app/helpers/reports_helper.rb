module ReportsHelper
  
  def ReportsHelpText(report)
    paragraph = ""
    
    case report
    when "Current Tasks"
      paragraph = "Displays just the Tasks that are not Completed (i.e., just the Tasks visible on the Kanban board)."
    when "Current Goals"
      paragraph = "Displays just the Goals that are not Completed (i.e., just the Goals visible on the Kanban board)."
    when "Status Report"
      paragraph = "Displays the Tasks and goals that are current and those that have been completed within the given time frame (either one day or one week). The user can also provide a narrative describing the actions taken during the time frame and actions to be taken."
    when "All Tasks Report"
      paragraph = "Displays every Task ever created by the user."
    when "All Goals Report"
      paragraph = "Displays every Goal ever created by the user."
    when "Productivity Report"
      paragraph = "Displays some basic statistical information regarding a user's historic productivity."
    when "Historical Task Report"
      paragraph = "The Historical Task Report displays all of the Historical records for a task, the category of the Historical change, and the date the change occurred. All records are group by Task."
    end
  end
end