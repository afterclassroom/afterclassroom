# See how all your routes lay out with "rake routes"
ActionController::Routing::Routes.draw do |map|
  map.feedback 'feedbacks', :controller => 'feedbacks', :action => 'create'
  map.new_feedback 'feedbacks/new', :controller => 'feedbacks', :action => 'new'
    
  # RESTful rewrites
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.login_ajax    '/login_ajax',    :controller => 'sessions', :action => 'login_ajax'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}
  
  map.user_troubleshooting '/users/troubleshooting', :controller => 'users', :action => 'troubleshooting'
  map.user_forgot_password '/users/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.user_reset_password  '/users/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  map.user_forgot_login    '/users/forgot_login',    :controller => 'users', :action => 'forgot_login'
  map.user_clueless        '/users/clueless',        :controller => 'users', :action => 'clueless'

  map.resources :learningtools, :collection => {
    :recommendtool => :get,
    :tooltab => :get,
    :populartab => :get,
    :verifiedtab => :get,
    :recentlyaddedtab => :get,
    :seealltab => :get,
    :pagingalltool => :get,
    :learninglounge => :get,
    :info => :get,
    :favorite => :get
  }
  map.resources :shoppings, :collection => {
    :mainpage => :get,
    :shoppingdetail => :get,
    :cat_nav => :get,
    :friendads => :get,
    :recentitems => :get
  }

  map.resources :playgames, :collection => {
    :recommendgame => :get,
    :info => :get,
    :gameslounge => :get,
    :favorite => :get,
    :gametab => :get,
    :populartab => :get,
    :verifiedtab => :get,
    :recentlyaddedtab => :get,
    :seealltab => :get,
    :pagingallgame => :get

  }

  map.resources :phoneapps, :collection => {
    :recommendapp => :get,
    :phonelounge => :get,
    :info => :get,
    :favorite => :get,
    :iphonepage => :get,
    :bberrypage => :get,
    :googleapppage => :get,
    :pagingphoneapps => :get,
    :phoneappstab => :get,
    :populartab => :get,
    :verifiedtab => :get,
    :recentlyaddedtab => :get,
    :seealltab => :get
  }
  
  # Users
  map.resources :users, :member => {
    :my_post => :get,
    :list_friends => :get,
    :my_favorite => :get,
    :delete_favorite => :get,
    :delete_friend => :get,
    :list_comments => :get,
    :show_comment => :get,
    :create_comment => :get,
    :delete_comment => :get,
    :edit_password => :get,
    :update_password => :put,
    :edit_email => :get,
    :update_email => :put,
    :update_avatar => :post} do |users|
    users.resources :messages,
      :collection => { :show_email => :get, :send_message => :get, :message_action => :post, :list_friend => :get }
    users.resources :settings,
      :collection => {
      :networks => :get,
      :notifications => :get,
      :language => :get,
      :payments => :get,
      :ads => :get,
      :setting => :get,
      :change_psw => :get,
      :save_psw => :get,
      :change_name => :get,
      :save_name => :get,
      :change_email => :get,
      :save_email => :get,
      :save_setting => :post}
    users.resources :profiles,
      :collection => {:show_profile => :get, :edit_infor => :get,
      :edit_edu_infor => :get, :edit_work_infor => :get,
      :update_about_yourself => :post, :update_infor => :post,
      :update_edu_infor => :post, :update_work_infor => :post,
      :my_favorite => :get
    }
    users.resources :student_lounges,
      :collection => {:invite_chat => :get, :add_users_to_chat => :get,
      :send_data => :get, :stop_chat => :get,
      :chanel_chat_content => :get, :friends_changed_message => :get,
      :friends_you_invited_chat => :get, :friends_want_you_chat => :get
    }
    users.resources :friends,
      :collection => {
      :search => :get,
      :find => :get,
      :find_email => :post,
      :display_email => :post,
      :recently_added => :get,
      :recently_updated => :get,
      :friend_request => :get,
      :list => :get,
      :invite => :get,
      :invite_by_list_email => :post,
      :invite_by_import_email => :post,
      :delete => :post,
      :accept => :post,
      :de_accept => :post}
    users.resources :stories, 
      :collection => {
      :friend_s => :get, :my_s => :get,
      :create_comment => :get, :delete_comment => :get
    }

    # Video Album
    users.resources :video_albums
    users.resources :videos, :collection => {:create_album => :get}

    # Music Album
    users.resources :music_albums
    users.resources :musics, :collection => {:create_album => :post, :friend_m => :get, :my_m => :get, :create_playlist => :get}
    
    # Photo Album
    users.resources :photo_albums
    users.resources :photos, :collection => {:create_album => :post, :friend_p => :get, :my_p => :get}
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
  map.resources :awareness_types
  map.resources :shipping_methods
  map.resources :functional_experiences

  # Posts
  map.resources :posts,
    :collection => {
    :rate_comment => :get,
    :create_comment => :get,
    :report_abuse => :get,
    :create_report_abuse => :get,
    :delete_comment => :get,
    :download => :get
  }
  map.resources :post_assignments, :collection => {
    :search => :get, :due_date => :get, :tag => :get
  }
  map.resources :post_projects, :collection => {
    :search => :get, :due_date => :get,
    :interesting => :get, :tag => :get
  }
  map.resources :post_tests, :collection => {
    :search => :get, :due_date => :get,
    :interesting => :get, :tag => :get
  }
  map.resources :post_exams, :collection => {
    :search => :get, :due_date => :get,
    :interesting => :get, :tag => :get
  }
  map.resources :post_qas, :collection => {
    :search => :get, :tag => :get,
    :interesting => :get, :top_answer => :get,
    :create_comment => :get, :show_comment => :get,
    :rate => :get, :require_rate => :get, :prefer => :get
  }
  map.resources :post_tutors, :collection => {
    :search => :get, :tag => :get,
    :effective => :get, :dont_hire => :get,
    :rate => :get, :require_rate => :get
  }
  map.resources :post_books, :collection => {
    :search => :get, :tag => :get,
    :good_books => :get, :dont_buy => :get,
    :rate => :get, :require_rate => :get
  }
  map.resources :post_jobs, :collection => {
    :search => :get, :tag => :get,
    :good_companies => :get, :worse_bosses => :get,
    :rate => :get, :require_rate => :get
  }
  map.resources :post_foods, :collection => {
    :search => :get, :tag => :get,
    :rate => :get, :require_rate => :get
  }
  map.resources :post_parties, :collection => {
    :search => :get, :show_rsvp => :get,
    :create_rsvp => :get, :tag => :get,
    :rate => :get, :require_rate => :get,
    :prefer => :get, :show_rsvp => :get
  }
  map.resources :post_myxes, :collection => {
    :search => :get, :tag => :get,
    :rate => :get, :require_rate => :get
  }
  map.resources :post_awarenesses, :collection => {
    :search => :get, :tag => :get,
    :rate => :get
  }
  map.resources :post_housings, :collection => {
    :search => :get, :tag => :get,
    :good_house => :get, :worse_house => :get,
    :rate => :get
  }
  map.resources :post_teamups, :collection => {
    :search => :get, :tag => :get,
    :good_org => :get, :worse_org => :get,
    :more_startup => :get, :rate => :get
  }

  # Exam/Test Schedules, Deadline bulletin, General bulletin
  map.resources :post_exam_schedules
  
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
