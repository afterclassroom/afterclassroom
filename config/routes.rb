Afterclassroom::Application.routes.draw do
  resources :shares

  # RESTful rewrites
  match '/signup' => 'users#new', :as => :signup
  match '/activate/:activation_code' => 'users#activate', :as => :activate
  match '/login' => 'sessions#new', :as => :login
  match '/login_ajax' => 'sessions#login_ajax', :as => :login_ajax
  match '/logout' => 'sessions#destroy', :as => :logout, :conditions => {:method => :delete}

  match '/users/troubleshooting' => 'users#troubleshooting', :as => :user_troubleshooting
  match '/users/forgot_password' => 'users#forgot_password', :as => :user_forgot_password
  match '/users/reset_password/:password_reset_code' => 'users#reset_password', :as => :user_reset_password
  match '/users/forgot_login' => 'users#forgot_login', :as => :user_forgot_login
  match '/users/clueless' => 'users#clueless', :as => :user_clueless

  # Users
  resources :users do
    member do
      get :edit_password, :edit_email
      put :update_password, :update_email
      post :update_avatar
    end

    resources :messages do
      collection do
        get :show_email, :send_message
        post :message_action
      end
    end

    resources :settings do
      collection do
        get :networks, :notifications, :language,
          :payments, :ads, :setting,
          :change_psw, :save_psw, :change_name,
          :save_name, :change_email, :save_email
        post :save_setting
      end
    end

    resources :profiles do
      collection do
        get :show_profile, :edit_infor, :edit_edu_infor,
          :edit_work_infor, :my_favorite
        post :update_about_yourself, :update_infor, :update_edu_infor, :update_work_infor
      end
    end

    resources :student_lounges do
      collection do
        get :chat, :invite_chat, :add_users_to_chat,
          :send_data, :stop_chat, :chanel_chat_content,
          :friends_changed_message, :friends_you_invited_chat, :friends_want_you_chat
      end
    end

    resources :friends do
      collection do
        get :search, :find, :recently_added, :recently_updated,
          :friend_request, :list, :invite,
          :send_invite_message, :show_invite, :become_a_fan
        post :find_email, :display_email, :invite_by_list_email,
          :invite_by_import_email, :delete, :accept, :de_accept
      end
    end

    resources :stories do
      collection do
        get :friend_s, :my_s, :create_comment, :delete_comment
      end
    end

    # Video Album
    resources :video_albums
    resources :videos do
      collection do
        get :create_album
      end
    end

    # Music Album
    resources :music_albums
    resources :musics do
      collection do
        get :friend_m, :my_m, :create_playlistend
        post :create_album, :upload
      end
    end

    # Photo Album
    resources :photo_albums
    resources :photos do
      collection do
        get :friend_p, :my_p
        post :create_album, :upload
      end
    end

    # Youtube
    resources :youtubes do
      new do
        post :upload
      end

      collection do
        get :authorise
      end
    end
  end

  # Sessions
  resource :session do
    collection do
      get :change_school
    end
  end

  # State
  resources :states

  # City
  resources :cities do 
    collection do
      get :state
    end
  end

  # School
  resources :schools do
    collection do
      get :state_or_city, :city
    end
  end

  # Department
  resources :department_categories
  resources :departments do 
    collection do
      get :create_department
    end
  end

  # Post Categories
  resources :post_categories
  resources :housing_categories
  resources :teamup_categories
  resources :party_types
  resources :job_types
  resources :awareness_types

  # Posts
  resources :posts do
    collection do
      get :rate_comment, :create_comment, :report_abuse, :create_report_abuse, :delete_comment, :download
    end
  end

  resources :post_assignments do
    collection do
      get :search, :due_date, :interesting, :tag
    end
  end

  resources :post_projects do
    collection do
      get :search, :due_date, :interesting, :tag
    end
  end

  resources :post_tests do
    collection do
      get :search, :interesting, :tag
    end
  end

  resources :post_exams do
    collection do
      get :search, :interesting, :tag
    end
  end

  resources :post_qas do
    collection do
      get :search, :tag, :interesting, :top_answer, :create_comment, :show_comment, :rate, :require_rate, :prefer
    end
  end

  resources :post_tutors do
    collection do
      get :search, :tag, :effective, :dont_hire, :rate, :require_rate
    end
  end

  resources :post_books do
    collection do
      get :search, :tag, :good_books, :dont_buy, :rate, :require_rate
    end
  end

  resources :post_jobs do
    collection do
      get :search, :tag, :good_companies, :bad_bosses,
        :rate, :require_rate, :my_job_list, :add_job,
        :employment_infor, :show_job_infor, :apply_job,
        :save_letter, :save_script, :save_resume
    end
  end

  resources :post_foods do
    collection do
      get :search, :tag, :rate, :require_rate
    end
  end

  resources :post_parties do
    collection do
      get :search, :show_rsvp, :create_rsvp,
        :tag, :rate, :require_rate,
        :prefer, :my_party_list, :add_party
    end
  end

  resources :post_myxes do
    collection do
      get :search, :tag, :rate, :require_rate
    end
  end

  resources :post_awarenesses do
    collection do
      get :search, :tag, :rate, :support, :view_results
    end
  end

  resources :post_housings do
    collection do
      get :search, :tag, :good_house, :worse_house, :rate
    end
  end

  resources :post_teamups do
    collection do
      get :search, :tag, :good_org, :worse_org, :more_startup, :rate
    end
  end

  # Exam/Test Schedules, Deadline bulletin, General bulletin
  resources :post_exam_schedules do
    collection do
      get :search, :tag, :rate
    end
  end

  # Feedback
  match 'feedbacks' => 'feedbacks#create', :as => :feedback
  match 'feedbacks/new' => 'feedbacks#new', :as => :new_feedback

  # Administration
  namespace :admin do
    resources :dashboards
    resources :settings
    resources :posts
    resources :users do
      member do
        put :suspend, :unsuspend, :activate, :reset_password
        delete :purge
      end

      collection do
        get :pending, :active, :suspended, :deleted
      end
    end
    root :to => 'dashboards#index'
  end

  # Dashboard as the default location
  root :to => 'dashboards#index'

  # Install the default routes as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'
end
