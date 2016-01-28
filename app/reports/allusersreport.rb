require "templates"

class AllUsersReport < Ruport::Controller
  stage :all_users_format
  finalize :standard_report
  
  def setup
    table =  Table([:id, :email, :name, :premiumaccount, :adminaccount, :passwordresetflag]) do |t|
      #t << record
      User.find(:all).each {|u| t << u.report_record() }
    end
    
    self.data = table
  end
  
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => AllUsersReport

    def build_all_users_format 
      #@output << erb(RAILS_ROOT + "/app/views/reports/_users.html.erb")
      pad_bottom(10) do
        add_text "All Users" 
      end                                                 
      
      draw_table(data, :width => 600)
      
      #data.to_pdf
      #draw_table(data)
    end
    
    def finalize_standard_report
      render_pdf
    end
  end
  
  
  class HTML < Ruport::Formatter::HTML
    
    renders :html, :for => AllUsersReport
    
    def build_all_users_format
      output << textile("h3 All Users")   
      output << data.to_html(:style => :justified)
    end
    
  end

end