module GoalsHelper
  
  def GoalHelpText()
    return "Click the 'Create Goal' button to create a new Goal.<br /><br />
      If a Goal's description is too long to fit on the Kanban board, double click on the Goal to view the Description.<br /><br />
      To edit a Goal, click the 'E' button and make the desired changes.<br /><br />
      If a Goal will not be addressed, then it can be Deleted by clicking the 'X' button.<br /><br />
      A Goal can be Completed by clicking the 'C' button. Completed Goals are removed from the Kanban board, but remain in the system for reporting purposes.<br /><br />"
  end
  
  def GoalTypeHelpText(goaltype)
    paragraph1 = ""
    
    case goaltype
    when "Daily"
      paragraph1 = "Daily Goals are those goals that are short enough to be completed in a day."
    when "Weekly"
      paragraph1 = "Weekly Goals are those goals that are short enough to be completed in a week."
    when "Monthly"
      paragraph1 = "Monthly Goals take up to a Month to complete."
    end
    
    return paragraph1
  end
end