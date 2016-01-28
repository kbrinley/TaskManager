Ruport::Formatter::Template.create(:statisticaltemplate) do |format|
  
  format.page = {
    :layout => :portait
  }            
            
  format.grouping = {
    :style => :separated
  }
                       
  format.text = {
    :font_size => 12,
    :justification => :left
  }                         
  
  format.table = {
    :font_size         => 10,
    :heading_font_size => 10,
    :maximum_width     => 720,
    :width             => 720
  }                          
  
  format.column = {
    :alignment => :right
  }                         
  
  format.heading = {
    :alignment => :right,
    :bold      => true
  }                   
  
end