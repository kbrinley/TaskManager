require "templates"

class StatusReport < Ruport::Controller
  stage :header, :report_body, :footer
  finalize :standard_report
  
  @@goal_data = nil
  
  def initialize
    @@goal_data = Table([:description, :goaltype_label, :datecompleted, :created_date, :last_updated_date])

  end
  
  def setup
    current_user = options[:currentuser]
    user_notes = options[:usernotes]
    time_span = options[:timespan]
    
    completed_category_id = current_user.category.find(:all, :conditions => {:listorder => 0 })[0].id
    
    
    # Which tasks do we display? 
    table =  Table([:description, :category_label, :created_date, :last_updated_date])do |t|
      if time_span == 'Daily'
        current_user.tasks.find(:all, :conditions =>
          ["updated_at > '#{1.day.ago}' or category_id <> '#{completed_category_id}'"]).each {|u| t << u.report_record}
      elsif time_span == 'Weekly'
        current_user.tasks.find(:all, :conditions =>
          ["updated_at > '#{1.week.ago}' or category_id <> '#{completed_category_id}'"]).each {|u| t << u.report_record}
      end
    end
    
    table.rename_columns(:description => "Description",
                         :category_label => "Task Category",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated")
    

    
    
    self.data = table
  end
  
  module Helpers
    def usernotes
      return options[:usernotes]
    end
    
    def timespan
      return options[:timespan]
    end
    
    def goaldata
      current_user = options[:currentuser]
      goal_type_id = Goaltype.find(:all, :conditions => [
        "label = '#{options[:timespan]}'"
      ])[0].id
    
    goal_data = Table([:description, :goaltype_label, :datecompleted, :created_date, :last_updated_date]) do |gt|
      if goal_type_id != nil
        current_user.goals.find(:all, :conditions =>
          ["(datecompleted > '#{1.day.ago}' OR datecompleted is null) AND goaltype_id = '#{goal_type_id}'"]
        ).each {|g| gt << g.report_record()}
      end
    end
      
    goal_data.rename_columns(:description => "Description",
                         :goaltype_label => "Goal Type",
                         :datecompleted => "Date Completed",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated")
                         
    return goal_data
    end
  end
  
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => StatusReport

     # <summary>
     # Generates the header for the report.
     # </summary>
     def build_header 
      pdf_writer.margins_in(1)
      if timespan == "Weekly"
        add_text "Status Report for the Week of " + Time.now.to_formatted_s(:date)
      else
        add_text "Status Report for " + Time.now.to_formatted_s(:date)
      end
     end

    # <summary>
    # Renders the report data on the Report in a table format.
    # </summary>
    def build_report_body
      #@output << erb(RAILS_ROOT + "/app/views/reports/_users.html.erb") 
      pad(10) do
        add_text usernotes
      end
      if timespan == "Daily" 
        add_text "Current Tasks and Tasks Modified in the last Day"
      elsif timespan == "Weekly"
        add_text "Current Tasks and Tasks Modified in the last Week"
      else
        add_text "Current Tasks"
      end
      pad(10) do
        draw_table(data, :width => 600)
      end
      if timespan == "Daily" 
        add_text "Current Goals and Goals Modified in the last Day"
      elsif timespan == "Weekly"
        add_text "Current Goals and Goals Modified in the last Week"
      else
        add_text "Current Goals"
      end
      pad(10) do
        draw_table(goaldata, :width => 600)
      end
    end
    
    # <summary>
    # Generates the copyright footer for the report.
    # </summary>
    def build_footer
      pad(10) do
        pdf_writer.y = pdf_writer.absolute_bottom_margin + 10
        add_text "Copyright 2010 - Sand Bridge Software", :font_size => 8
      end
    end
    
    def finalize_standard_report
      render_pdf
    end
  end

end