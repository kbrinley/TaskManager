require 'allusersreport'
require 'alltasksreport'
require 'allgoalsreport'
require 'statisticalreport'
require 'taskhistoricalreport'
require 'statusreport'

# <summary>
# Lists and Generates the reports for the application.
# </summary>
class ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user
  before_filter :premium_user
  
  # <summary>
  # Provides links to the Reports valid for the current user.
  # </summary>
  def index
    @title = "Reports"
    @taskhistorytotal = @current_user.taskhistories.count
  end
  
  # <summary>
  # An Administrator only report that lists all of the system's users and some basic info about them.
  # </summary> 
  def users
    pdf = AllUsersReport.render_pdf
    send_data pdf,
      :type => "application/pdf",
      :filename => "AllUsers.pdf"
  end
  
  # <summary>
  # Lists all of the tasks for the user, including tasks that have been completed.
  # </summary>
  def alltasks
    pdf = AllTasksReport.render_pdf(:currentuser => @current_user, :allflag => true)
    send_data pdf,
      :type => "application/pdf",
      :filename => "AllTasks.pdf"
  end
  
  # <summary>
  # Lists all of the goals for the user, including goals that have been completed.
  # </summary>
  def allgoals
    pdf = AllGoalsReport.render_pdf(:currentuser => @current_user, :allflag => true)
    send_data pdf,
      :type => "application/pdf",
      :filename => "AllGoals.pdf"
  end
  
  # <summary>
  # Lists the current active goals for the user.
  # </summary>
  def currentgoals
    pdf = AllGoalsReport.render_pdf(:currentuser => @current_user, :allflag => false)
    send_data pdf,
      :type => "application/pdf",
      :filename => "CurrentGoals.pdf"
  end

  # <summary>
  # Lists the current tasks for the user.
  # </summary>
  def currenttasks
    pdf = AllTasksReport.render_pdf(:currentuser => @current_user, :allflag => false)
    send_data pdf,
      :type => "application/pdf",
      :filename => "CurrentTasks.pdf"
  end
  
  # <summary>
  # Generates the Productivity Report, which contains numerous calculations around productivity.
  # </summary>
  def statistics
    pdf = StatisticalReport.render_pdf(:currentuser => @current_user)
    send_data pdf,
      :type => "application/pdf",
      :filename => "StatisticalReport.pdf"
  end
  
  # <summary>
  # Lists the Task Histories of each task, listing the category changes and date.
  # </summary>
  def historictasks
    pdf = TaskHistoricalReport.render_pdf(:currentuser => @current_user)
    send_data pdf,
      :type => "application/pdf",
      :filename => "HistoricalReport.pdf"
  end
  
  def statusreport
    @title = "Enter data for Status Report"
  end
  
  def generatestatusreport
    pdf = StatusReport.render_pdf(:currentuser => @current_user, :usernotes => params[:usernotes], :timespan => params[:timespan][:selected])
    send_data pdf,
      :type => "application/pdf",
      :filename => "StatusReport-" + params[:timespan][:selected] + Time.now.to_formatted_s(:date) + ".pdf"
  end

  private
  def authenticate
    deny_access unless signed_in?
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end