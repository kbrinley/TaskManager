module TasksHelper

  def TaskHelpText()
    return "Click the 'Create Tasks' button to create a task.<br /><br />
    If a Task's description is too long to fit on the Kanban board, double click on the Task to view the Description.<br /><br />
    To edit a Task, click the 'E' button and make the desired changes.<br /><br />
    If a Task has not been Delivered, then it can be Deleted by clicking the 'X' button. If a Task is deleted, the Task record and any historical information regarding the Task is deleted.<br /><br />
    If a Task has been moved to the Delivered queue, it can be Completed by clicking the 'C' button. Completed Tasks are removed from the Kanban board, but remain in the system for reporting purposes.<br /><br />
    If a Task needs to be moved to a different queue, but not changes are necessary to its Description, then the user can drag the Task to the other queue and drop it."
  end
  
  def CategoryHelpText(category)
    paragraph1 = ""
    paragraph2 = "After each category is a number in parentheses. This number refers to the maximum number of Tasks that can be assigned to the category at any given time. This limits the number of Tasks that can be on a user's Kanban board at any given time."
  
    case category
    when "Backlog"
      paragraph1 = "The Backlog Category holds tasks that have not been started. New Tasks default to the Backlog category.<br /><br />"
    when "In Progress"
      paragraph1 = "The In Progress Category refers to Tasks that are actively being worked on. The system defaults the number of In Progress Tasks to 3 to limit the user in working on just a few tasks at a time.<br /><br />"
    when "On Hold"
      paragraph1 = "Tasks that have been started but are delayed, or tasks that have been assigned to someone else belong in the On Hold category.<br /><br />"
    when "Ready to Demo"
      paragraph1 = "Tasks that have been addressed, but not officially delivered go into the Ready to Demo queue. Ideally, at this point the user would demo the functionality to others, then progress it to the next queue.<br /><br />"
    when "Delivered"
      paragraph1 = "After being addressed and demoed (if necessary), the Task moves to the Delivered queue. Here, the user can 'Complete' a task, thus removing it from the Kanban board. The task and its history remains in the system, but the Task itself cannot be worked on anymore.<br /><br />"
    end
    
    return paragraph1 + paragraph2
    
  end

end
