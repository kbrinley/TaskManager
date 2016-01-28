ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.resources :users
  map.resources :sessions, :only => [:new, :create, :destroy]
  map.resources :tasks #, :only => [:index, :new, :edit, :destroy]
  map.resources :goals
  map.resources :reports
  map.resources :categories
  #map.resources :emailers
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'pages', :action => 'home'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  map.about '/about', :controller => 'pages', :action => 'about'
  map.help '/help', :controller => 'pages', :action => 'help'
  map.aboutus '/aboutus', :controller => 'pages', :action => 'aboutus'
  map.tour '/tour', :controller => 'pages', :action => 'tour'
  map.testimonials '/testimonials', :controller => 'pages', :action => 'testimonials'
  map.pricing '/pricing', :controller => 'pages', :action => 'pricing'
  map.buypremium '/buypremium', :controller => 'pages', :action => 'buypremium'
  map.faq '/faq', :controller => 'pages', :action => 'faq'
  map.sitemap '/sitemap', :controller => 'pages', :action => 'sitemap'
  map.privacy '/privacy', :controller => 'pages', :action => 'privacy'
  map.terms '/terms', :controller => 'pages', :action => 'terms'
  map.mailinglist '/mailinglist', :controller => 'pages', :action => 'mailinglist'
  map.accountexpired '/accountexpired', :controller => 'pages', :action => 'accountexpired'
  map.links '/links', :controller => 'pages', :action => 'links'
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.makepremium '/makepremium', :controller => 'users', :action => 'makepremium' 
  map.forgot '/forgot', :controller => 'users', :action => 'forgot'
  map.reset  'reset/:reset_code', :controller => 'users', :action => 'reset'
  
  map.signin '/signin', :controller => 'sessions', :action => 'new'
  map.signout '/signout', :controller => 'sessions', :action => 'destroy'
  
  #map.sendmail '/sendmail', :controller => 'emailers', :action => 'index'
  
  #map.task '/task', :controller => 'tasks', :action => 'index'
  
end
