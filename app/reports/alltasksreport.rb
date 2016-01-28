require "templates"

# <summary>
# Generates the All Tasks and Current Tasks reports
# </summary>
class AllTasksReport < Ruport::Controller
  stage :header, :report_body, :footer
  finalize :standard_report
  
  # <summary>
  # Depending on :allflag, generates the All Tasks or Current Tasks report.
  #   For All Tasks, no conditions are required.
  #   For Current Tasks, we filter out all "Completed" tasks.
  # </summary>
  def setup
    current_user = options[:currentuser]
    all_flag = options[:allflag]
    if current_user.percentcompleteenabled
      table =  Table([:description, :category_label, :created_date, :last_updated_date, :percentcomplete]) do |t|
        if all_flag
          current_user.tasks.find(:all).each {|u| t << u.report_record() }
        else
          completed_category = current_user.category.find(:all, :conditions => [
            "label = 'Completed'"
          ])
          current_user.tasks.find(:all).each {|u| t << u.report_record unless u.category_id == completed_category[0].id}
        end
      end
      table.rename_columns(:description => "Description",
                         :category_label => "Task Category",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated",
                         :percentcomplete => "Percent Complete")
    else
      table =  Table([:description, :category_label, :created_date, :last_updated_date]) do |t|
        if all_flag
          current_user.tasks.find(:all).each {|u| t << u.report_record() }
        else
          completed_category = current_user.category.find(:all, :conditions => [
            "label = 'Completed'"
          ])
          current_user.tasks.find(:all).each {|u| t << u.report_record unless u.category_id == completed_category[0].id}
        end
      end
      table.rename_columns(:description => "Description",
                         :category_label => "Task Category",
                         :created_date => "Date Created",
                         :last_updated_date => "Date Last Updated")
    end
    
    self.data = table
  end
  
  # <summary>
  # Helper to return the All Flag value so it can be used in the PDF Formatter.
  # </summary>
  module Helpers
    def allflag
      return options[:allflag]
    end
  end
  
  # <summary>
  # Renders the report in PDF format.
  # </summary>
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => AllTasksReport

 # Possible code to set a footer on each page???
 # Code obtained here:http://groups.google.com/group/ruby-reports/browse_thread/thread/8a8073e022389335?hl=en
 # def all_pages
 #    ypos = cursor
 #    pdf_writer.open_object do |o|
 #      pdf_writer.save_state
 #      yield
 #      pdf_writer.restore_state
 #      pdf_writer.close_object
 #      pdf_writer.add_object(o,:all_pages)
 #    end
 #    move_cursor_to ypos
 #  end 
 
     # <summary>
     # Generates the header for the report.
     # </summary>
     def build_header 
      pdf_writer.margins_in(1)
      
      pad_bottom(10) do
        if allflag
          add_text "All Tasks"
        else
          add_text "Current Tasks"
        end
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

    # <summary>
    # Renders the report data on the Report in a table format.
    # </summary>
    def build_report_body
      draw_table(data, :width => 600)
    end
    
    # <summary>
    # Returns the PDF.
    # </summary>
    def finalize_standard_report
      render_pdf
    end
  end
end