require "templates"

class TaskHistoricalReport < Ruport::Controller
  stage :header, :report_body, :footer
  finalize :standard_report
  
  def setup
    current_user = options[:currentuser]
    table =  Table([:task_id, :task_description, :category_label, :date]) do |t|
      current_user.taskhistories.find(:all).each {|u| t << u.report_record() }
    end
    
    #table.rename_columns(:task_id => "Task ID",
    #                     :task_description => "Task Description",
    #                     :category_label => "Category",
    #                     :date => "Date Updated")
    
    grouping = Ruport::Data::Grouping.new(table, :by => :task_id)
    
    table2 = Table([:description, :action, :date])
    
    grouping.each do |id,group|
      group.sort_rows_by(:date, :order => :descending)
      group.each do |entry|
        table2 << {:description => entry[:task_description],
                 :action => entry[:category_label],
                 :date => entry[:date]}  
      end
      table2 << {} #Inserts a blank row to seperate task records
    end
    
    table2.rename_columns(:description => "Task Description",
                          :action => "Action",
                          :date => "Action Date")
    
    self.data = table2
  end
  
  #module Helpers
  #  
  #end
  
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => TaskHistoricalReport                                                
      
    def build_header 
      pdf_writer.margins_in(1)
      
      pad_bottom(10) do
        add_text "Historical Task Report"
      end           
    end

    def build_footer
      pad(10) do
        pdf_writer.y = pdf_writer.absolute_bottom_margin + 10
        add_text "Copyright 2010 - Sand Bridge Software", :font_size => 8
      end
    end

    def build_report_body
      draw_table(data, :width => 600)
    end
    
    def finalize_standard_report
      render_pdf
    end
  end
end