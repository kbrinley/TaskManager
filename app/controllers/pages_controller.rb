class PagesController < ApplicationController
  def home
    @title = "Kanban For Developers"
  end

  def contact
    @title = "Kanban For Developers: Contact Us"
  end

  def about
    @title = "About Kanban For Developers"
  end
  
  def help
    @title = "Kanban For Developers: Help"
  end
  
  def aboutus
    @title = "About Us"
  end
  
  def tour
    @title = "Kanban For Developers: Product Tour"
  end
  
  def testimonials
    @title = "What Others are saying about Kanban for Developers"
  end
  
  def pricing
    @title = "Kanban For Developers: Pricing Information"
  end
  
  def buypremium
    @title = "Purchase Premium account"
  end
  
  def faq
    @title = "Kanban For Developers: FAQ"
  end
  
  def sitemap
    @title = "Kanban For Developers: Sitemap"
  end
  
  def privacy
    @title = "Kanban For Developers: Privacy Notice"
  end
  
  def terms
    @title = "Kanban For Developers: Terms and Conditions"
  end
  
  def mailinglist
    @title = "Kanban For Developers: Join our mailing list"
  end
  
  def accountexpired
    @title = "Kanban For Developers"
  end
  
  def links
    @title = "Kanban and Agile Software Resources"
  end
  
  def statistics
    @title = "Kanban for Developers: Statistics"
    
    if (params[:key] == "513812317cinblofis")
      Emailer.deliver_statistics()
    end
  end
end
