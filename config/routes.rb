Afterclassroom::Application.routes.draw do

  # RESTful rewrites
  match '/signup' => 'users#new', :as => :signup
  match '/activate/:activation_code' => 'users#activate', :as => :activate
  match '/logout' => 'sessions#destroy', :as => :logout, :conditions => {:method => :delete}

  match '/users/troubleshooting' => 'users#troubleshooting', :as => :user_troubleshooting
  match '/users/forgot_password' => 'users#forgot_password', :as => :user_forgot_password
  match '/users/reset_password/:password_reset_code' => 'users#reset_password', :as => :user_reset_password
  match '/users/forgot_login' => 'users#forgot_login', :as => :user_forgot_login
  match '/users/clueless' => 'users#clueless', :as => :user_clueless

  resources :forums do 
    collection do
      get :delcmt, :search, :see_all_top_fr, :view_all_comments, :view_all_no_loggin, :delfrm, :view_fr
      post :addfr, :save_edit, :savecmt
    end
  end
  resources :press_infos do
    collection do
      get :view_pr, :view_detail, :delpr, :searchpr
      post :save
    end
  end
  # Users
  resources :users do
    member do
      get :edit_password, :edit_email, :show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photo_album, :show_musics, :show_music_album, :show_videos, :show_detail_video, :show_friends, :show_fans, :warning
      put :update_password, :update_email
      post :update_avatar
    end

    resources :messages do
      collection do
        get :show_email, :list_friend, :delete_message
        post :message_action, :send_message
      end
    end

    resources :settings do
      collection do
        get :networks, :notifications, :language,
          :payments, :ads, :setting, :private,
          :change_psw, :save_psw, :change_name,
          :save_name, :change_email, :save_email,
          :change_time_zone, :save_time_zone
        post :save_setting, :save_private_setting
      end
    end
 
    resources :profiles do
      collection do
        get :show_profile, :edit_infor, :edit_edu_infor,
          :edit_work_infor, :my_favorite, :fan, :delete_fans
        post :update_about_yourself, :update_infor, :update_edu_infor, :update_work_infor
      end
    end

    resources :student_lounges do
      collection do
        get :chat, :invite_chat, :add_users_to_chat, :stop_chat, :chanel_chat_content,
          :friends_changed_message, :friends_you_invited_chat, :friends_want_you_chat, :friends_online
        post :send_data
      end
    end

    resources :friends do
      collection do
        get :search, :find, :find_people, :recently_added, :recently_updated,
          :friend_request, :list, :invite, :display_email, :add_to_group,
          :send_invite_message, :show_invite, :become_a_fan, :accept, :de_accept
        post :find_email, :invite_by_list_email,
          :invite_by_import_email, :delete
      end
    end

    resources :stories do
      collection do
        get :friend_s, :my_s, :my_draft, :draft, :create_comment, :delete_comment, :delete_all
      end
    end

    # Music Album
    resources :music_albums do
      collection do
        get :delete_all, :delete_musics
      end
    end
    
    resources :musics do
      collection do
        get :friend_m, :my_m, :create_playlist, :create_form, :play_list
        post :create_album, :upload
      end
    end

    # Photo Album
    resources :photo_albums do
      collection do
        get :delete_all, :delete_photos
      end
    end
    
    # Videos
    resources :videos do
      collection do
        get :friend_p, :my_p, :create_form, :delete_videos, :update_video
      end
    end
    
    resources :photos do
      collection do
        get :friend_p, :my_p, :create_form, :destroy_all, :show_album
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
  
    # Post managements
    resources :post_managements do
      collection do
        get :with_type, :delete_all
      end
    end
    
    # Share files
    resources :shares
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
      get :report_abuse, :create_report_abuse, :delete_comment, :download, :view_all_comments
      post :create_comment, :create_comment_on_list
    end
  end

  resources :post_assignments do
    collection do
      get :search, :due_date, :interesting, :tag, :quick_post_form
    end
  end

  resources :post_projects do
    collection do
      get :search, :due_date, :interesting, :tag, :quick_post_form
    end
  end

  resources :post_tests do
    collection do
      get :search, :interesting, :tag, :quick_post_form
    end
  end
  
  resources :post_exams do
    collection do
      get :search, :interesting, :tag, :quick_post_form
    end
  end

  resources :post_events do
    collection do
      get :search, :tag, :rate
    end
  end

  resources :post_qas do
    collection do
      get :search, :tag, :interesting, :top_answer, :create_comment, :rate, :require_rate, :prefer, :sendmail
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
        :save_letter, :save_script, :save_resume, :delete_job_list
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
        :prefer, :my_party_list, :add_party, :delete_party_list, :sendmail
    end
  end

  resources :post_myxes do
    collection do
      get :search, :tag, :rate, :require_rate
    end
  end

  resources :post_awarenesses do
    collection do
      get :search, :tag, :rate, :support, :require_rate
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
  
  resources :ajax_not_login do
    collection do
      get :show_comment, :rate_comment, :view_results
    end
  end
  
  # Feedback
  match 'feedbacks' => 'feedbacks#create', :as => :feedback
  match 'feedbacks/new' => 'feedbacks#new', :as => :new_feedback

  # Tags
  resources :tags do
    collection do
      get :show_tags, :show_tags_list
    end
  end
  
  #Simple Captcha
  match 'simple_captcha/:id', :to => 'simple_captcha#show', :as => :simple_captcha
  
  # Administration
  namespace :admin do
    resources :dashboards
    resources :settings
    resources :posts do
      collection do
        get :with_type
      end
    end
    
    resources :setnotifies do
      collection do
        get :addnew
        get :delete
        get :edit
        post :save_edit
        post :save
      end
    end

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
