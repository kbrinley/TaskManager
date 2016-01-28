require "statisticstemplate"

# <summary>
# Generates the Productivity (or Statistical Report).
# </summary>
class StatisticalReport < Ruport::Controller
  stage :header, :report_body, :footer
  finalize :standard_report
  
  def setup
    current_user = options[:currentuser]
    
    # Since this is not a table based report, go straight to the Hash value for the Statistical values.
    self.data = current_user.statistical_report_record
  end
  
  # <summary>
  # Formats the report for PDF generation.
  # </summary>
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatisticalReport                                                
      
    # <summary>
    # Uses the default template, but sets the layout to portrait
    # </summary>  
    def apply_template
      options.layout = :portrait
    end
      
    # <summary>
    # Generates the Header for the report, sets the margins, and the font
    # </summary>  
    def build_header 
      pdf_writer.margins_in(1, 1.5)
      pdf_writer.select_font "Courier"
      
      pad_bottom(10) do
        add_text "Statistical Report", :justification => :center
      end           
    end

    # <summary>
    # Generates the copyright footer for the report.
    # </summary>
    def build_footer
      pad(10) do
        pdf_writer.y = pdf_writer.absolute_bottom_margin + 10
        add_text "Copyright 2010 - Sand Bridge Software", :font_size => 8, :justification => :center
      end
    end

    # <summary>
    # Generates the body of the report. In this case, we place each label and calculation
    # on a line. Allignment works out, because we had set the font to Courier, which allots
    # the same width to each charecter.
    # </summary>
    def build_report_body
      # This will be a bit more complicated for Statistical Reports.
      pad(10) do
        add_text "Average Time to fix issues (in hours):          " + data[:avg_time_to_fix].to_s
      end
      add_text "Average Day's Tasks are open:                   " + data[:avg_days_open].to_s
      pad(10) do
        add_text "New Tasks added last week:                      " + data[:new_tasks_last_week].to_s
      end
      add_text "New Tasks added last month:                     " + data[:new_tasks_last_month].to_s
      pad(10) do
        add_text "New Tasks added last year:                      " + data[:new_tasks_last_year].to_s 
      end
      add_text "Completed Tasks last week:                      " + data[:completed_tasks_last_week].to_s
      pad(10) do
        add_text "Completed Tasks last month:                     " + data[:completed_tasks_last_month].to_s
      end
      add_text "Completed Tasks last year:                      " + data[:completed_tasks_last_year].to_s
      pad(10) do
        add_text "Increase in Task backlog:                       " + data[:task_back_log_increase].to_s
      end
      #add_text "Number of re-opened Tasks:                      " + data[:num_of_rejected_defects].to_s
      #pad(10) do
      #  add_text "Percentage of re-opened Tasks:                  " + data[:percent_rejected_defects].to_s
      #end
      #add_text "Task Velocity:                                  " + data[:velocity].to_s
      add_text "Goal Completion Rate Week-to-date:              " + data[:wtd_goal_completion_rate].to_s
      pad(10) do
        add_text "Goal Failure Rate Week-to-date:                 " + (100.0 - data[:wtd_goal_completion_rate]).to_s
      end
      add_text "Goal Completion Rate Month-to-date:             " + data[:mtd_goal_completion_rate].to_s
      pad(10) do
        add_text "Goal Failure Rate Month-to-date:                " + (100.0 - data[:mtd_goal_completion_rate]).to_s
      end
      add_text "Goal Completion Rate Year-to-date:              " + data[:ytd_goal_completion_rate].to_s
      pad(10) do
        add_text "Goal Failure Rate Year-to-date:                 " + (100.0 - data[:ytd_goal_completion_rate]).to_s
      end
      add_text "Overall Goal Completion Rate:                   " + data[:goal_completion_rate].to_s
      pad(10) do
        add_text "Overall Goal Failure Rate:                      " + (100.0 - data[:goal_completion_rate]).to_s
      end
    end
    
    # <summary>
    # Generates the PDF
    # </summary>
    def finalize_standard_report
      render_pdf
    end
  end
end