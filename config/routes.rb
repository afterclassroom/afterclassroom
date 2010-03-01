# See how all your routes lay out with "rake routes"
ActionController::Routing::Routes.draw do |map|
  
  # RESTful rewrites
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}
  
  map.user_troubleshooting '/users/troubleshooting', :controller => 'users', :action => 'troubleshooting'
  map.user_forgot_password '/users/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.user_reset_password  '/users/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  map.user_forgot_login    '/users/forgot_login',    :controller => 'users', :action => 'forgot_login'
  map.user_clueless        '/users/clueless',        :controller => 'users', :action => 'clueless'
  
  # Users
  map.resources :users, :member => {
    :dashboard => :get,
    :my_post => :get,
    :list_friends => :get,
    :my_favorite => :get,
    :delete_favorite => :get,
    :delete_friend => :get,
    :list_comments => :get,
    :show_comment => :get,
    :create_comment => :get,
    :delete_comment => :get,
    :update_i_am_doing => :put,
    :edit_information => :get,
    :update_information => :put,
    :edit_education => :get,
    :update_education => :put,
    :edit_employment => :get,
    :update_employment => :put,
    :edit_password => :get,
    :update_password => :put,
    :edit_email => :get,
    :update_email => :put,
    :update_avatar => :put,} do |users|
    users.resources :messages, :collection => { :delete_selected => :post, :send_message => :get, :show_email => :get }
  end
  
  # Sessions
  map.resource :session, :collection => {:change_school => :get}
  
  # State
  map.resources :states
  
  # City
  map.resources :cities, :collection => {:state => :get}
  
  # School
  map.resources :schools, :collection => {:state_or_city => :get, :city => :get}
  
  # Department
  map.resources :department_categories
  map.resources :departments, :collection => {:create_department => :get}

  # Post Categories
  map.resources :post_categories
  map.resources :housing_categories
  map.resources :teamup_categories
  map.resources :party_types
  map.resources :job_types
  map.resources :awareness_issues
  map.resources :shipping_methods
  map.resources :functional_experiences

  # Posts
  map.resources :posts, :member => {
    :rate => :post},
    :collection => {
    :list_comments => :get,
    :create_comment => :get,
    :delete_comment => :get,
    :post_dispatch => :get,
    :list_favorites => :get,
    :add_to_favorite => :get,
    :add_to_favorite_in_detail => :get,
    :download => :get
  }
  map.resources :post_assignments, :collection => {
    :search => :get, :due_date => :get, :tag => :get
  }
  map.resources :post_myxes, :collection => {
    :search => :get, :due_date => :get,
    :profrating => :get, :more_worse => :get,
    :more_good => :get
  }
  map.resources :post_projects, :collection => {
    :search => :get, :due_date => :get, :interesting => :get
  }
  map.resources :post_tests, :collection => {
    :search => :get, :due_date => :get
  }
  map.resources :post_exams, :collection => {
    :search => :get, :due_date => :get
  }
  map.resources :post_qas, :collection => {
    :search => :get
  }
  map.resources :post_foods, :collection => {
    :search => :get
  }
  map.resources :post_teamups, :collection => {
    :search => :get,
    :more_startup => :get,
    :index => :get,
    :teamrating => :get
  }
  map.resources :post_parties, :collection => {
    :search => :get,
    :show_rsvp => :get,
    :create_rsvp => :get
  }
  map.resources :post_awarenesses, :collection => {
    :search => :get
  }
  map.resources :post_jobs, :collection => {
    :search => :get
  }
  map.resources :post_books, :collection => {
    :search => :get
  }
  map.resources :post_tutors, :collection => {
    :search => :get
  }
  map.resources :post_housings, :collection => {
    :search => :get
  }
  # Stories
  map.resources :stories, :collection => {:create_comment => :get, :delete_comment => :get}

  # Video Album
  map.resources :video_albums
  map.resources :videos, :collection => {:create_album => :get}

  # Music Album
  map.resources :music_albums
  map.resources :musics, :collection => {:create_album => :get}

  # Photo Album
  map.resources :photo_albums
  map.resources :photos, :collection => {:create_album => :get}
  
  # Administration
  map.namespace(:admin) do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :settings
    admin.resources :users, :member => { :suspend   => :put,
      :unsuspend => :put,
      :activate  => :put,
      :purge     => :delete,
      :reset_password => :put },
      :collection => { :pending   => :get,
      :active    => :get,
      :suspended => :get,
      :deleted   => :get }
  end
  
  # Dashboard as the default location
  map.root :controller => 'dashboard', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
