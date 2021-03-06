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

  map.resources :pin_images
  map.resources :users, :member => {:approve => :get, :update_password => :put}
  map.resource :session
  
  map.resources :regions do |region| 
    region.resources :pins, :collection => {:new_printable => :get}
    region.resources :areas
  end

  map.namespace :admin do |admin|
    admin.resources :regions do |regions|
      regions.resources :region_vertices, :collection => {:delete_all => :delete}
      regions.resources :users
    end
    admin.resources :users
  end
  
  map.namespace :region_admin do |region_admin|
    region_admin.resources :regions do |regions|
      regions.resources :pins
      regions.resources :areas
    end
  end

  map.root :controller => "regions", :action => "index"

  # See how all your routes lay out with "rake routes"

end
