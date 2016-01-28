require "templates"

# <summary>
# Renders the All Goals and Current Goals reports
# </summary>
class AllGoalsReport < Ruport::Controller
  stage :header, :report_body, :footer
  finalize :standard_report
  
  # <summary>
  # Assembles the data for the report generation.
  # </summary>
  def setup
    current_user = options[:currentuser]
    all_flag = options[:allflag]
    if current_user.percentcompleteenabled
      table =  Table([:description, :goaltype_label, :datecompleted, :created_date, :last_updated_date, :percentcomplete]) do |t|
        if all_flag
          current_user.goals.find(:all).each {|g| t << g.report_record()}
        else
          current_user.goals.find(:all).each {|u| t << u.report_record unless u.datecompleted != nil}
        end
      end
      
      table.rename_columns(:description => "Description",
                         :goaltype_label => "Goal Type",
                         :datecompleted => "Date Completed",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated",
                         :percentcomplete => "Percent Complete")

    else
      table =  Table([:description, :goaltype_label, :datecompleted, :created_date, :last_updated_date]) do |t|
        if all_flag
          current_user.goals.find(:all).each {|g| t << g.report_record()}
        else
          current_user.goals.find(:all).each {|u| t << u.report_record unless u.datecompleted != nil}
        end
      end

      table.rename_columns(:description => "Description",
                         :goaltype_label => "Goal Type",
                         :datecompleted => "Date Completed",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated")

    
    end

    self.data = table
  end
  
  # <summary>
  # Returns the Allflag for use in the PDF generator
  # </summary>
  module Helpers
    def allflag
      return options[:allflag]
    end
  end
  
  # <summary>
  # Formats and Generates the PDF report.
  # </summary>
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => AllGoalsReport

    # <summary>
    # Sets the margins and outputs the report header.
    # </summary>
    def build_header 
      pdf_writer.margins_in(1)
      
      pad_bottom(10) do
        if allflag
          add_text "All Goals"
        else
          add_text "Current Goals"
        end
      end           
      
    end

    # <summary>
    # Places the Copyright notice on the report
    # </summary>
    def build_footer
      pad(10) do
        pdf_writer.y = pdf_writer.absolute_bottom_margin + 10
        add_text "Copyright 2010 - Sand Bridge Software", :font_size => 8
      end
    end

    # <summary>
    # Renders the report data in a table
    # </summary>
    def build_report_body
      draw_table(data, :width => 700)
    end

    # <summary>
    # Returns the report in PDF format.
    # </summary>
    def finalize_standard_report
      render_pdf
    end
  end  
end