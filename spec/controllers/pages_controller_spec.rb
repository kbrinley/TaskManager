require 'spec_helper'

describe PagesController do
  integrate_views
  
  shared_examples_for "All Pages" do
      it "should be successful" do
        get @page
        response.should be_success
      end
      
      it "should have the right title" do
        get @page
        response.should have_tag("title", @title)
      end
      
      it "should contain a menu" do
        get @page
        response.should have_tag("a", "Home")
        response.should have_tag("a", "Tour")
        response.should have_tag("a", "Pricing")
        response.should have_tag("a", "Sign up")
        response.should have_tag("a", "Sign in")
      end
      
      it "should contain a footer menu" do
        get @page
        response.should have_tag("a", "FAQ")
        response.should have_tag("a", "Sitemap")
        response.should have_tag("a", "Privacy Policy")
        response.should have_tag("a", "Terms and Conditions")
        response.should have_tag("a", "Contact Us")
        response.should have_tag("a", "About Us")
        response.should have_tag("a", "Help")
        response.should have_tag("a", "Our Blog")
      end
    end
  
  it "should use PagesController" do
    controller.should be_an_instance_of(PagesController)
  end
  
  describe "GET 'home'" do
    before(:all) do
      @page = 'home'
      @title = "Kanban For Developers"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'contact'" do
    before(:all) do
      @page = 'contact'
      @title = "Kanban For Developers: Contact Us"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'about'" do
    before(:all) do
      @page = 'about'
      @title = "About Kanban For Developers"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'help'" do
    before(:all) do
      @page = 'help'
      @title = "Kanban For Developers: Help"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'aboutus'" do
    before(:all) do
      @page = 'aboutus'
      @title = "About Us"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'tour'" do
    before(:all) do
      @page = 'tour'
      @title = "Kanban For Developers: Product Tour"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'testimonials'" do
    before(:all) do
      @page = 'testimonials'
      @title = "What Others are saying about Kanban for Developers"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'pricing'" do
    before(:all) do
      @page = 'pricing'
      @title = "Kanban For Developers: Pricing Information"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'buypremium'" do
    before(:all) do
      @page = 'buypremium'
      @title = "Purchase Premium account"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'faq'" do
    before(:all) do
      @page = 'faq'
      @title = "Kanban For Developers: FAQ"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'sitemap'" do
    before(:all) do
      @page = 'sitemap'
      @title = "Kanban For Developers: Sitemap"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'privacy'" do
    before(:all) do
      @page = 'privacy'
      @title = "Kanban For Developers: Privacy Notice"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'terms'" do
    before(:all) do
      @page = 'terms'
      @title = "Kanban For Developers: Terms and Conditions"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'mailinglist'" do
    before(:all) do
      @page = 'mailinglist'
      @title = "Kanban For Developers: Join our mailing list"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
  
  describe "Get 'accountexpired'" do
    before(:all) do
      @page = 'accountexpired'
      @title = "Kanban For Developers"
      #login_as_admin
    end
    
    it_should_behave_like "All Pages"
  end
end