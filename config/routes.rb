Afterclassroom::Application.routes.draw do
  resources :omnitauths

  get 'kindeditor/images_list'

  post 'kindeditor/upload'

  # RESTful rewrites
	match '/login' => 'sessions#new', :as => :login
  match '/signup' => 'users#new', :as => :signup
  match '/activate/:activation_code' => 'users#activate', :as => :activate
  match '/logout' => 'sessions#destroy', :as => :logout, :conditions => {:method => :delete}

  match '/users/troubleshooting' => 'users#troubleshooting', :as => :user_troubleshooting
  match '/users/forgot_password' => 'users#forgot_password', :as => :user_forgot_password
  match '/users/reset_password/:password_reset_code' => 'users#reset_password', :as => :user_reset_password
  match '/users/forgot_login' => 'users#forgot_login', :as => :user_forgot_login
  match '/users/clueless' => 'users#clueless', :as => :user_clueless
  
  # Users
  resources :users do
    member do
      get :edit_password, :edit_email, :show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photos_with_list, :show_photo_album, :show_photo_detail, :show_musics, :show_music_album, :show_videos, :show_detail_video, :show_friends, :show_fans, :warning, :warning_media,
        :list_friend_to_tag
      put :update_password, :update_email
      post :update_avatar, :remove_tagged, :add_tag, :tag_decision
    end
	
    #Messages
    resources :messages do
      collection do
        get :show_email, :list_friend, :delete_message
        post :message_action, :send_message
      end
    end
   
    #Learning tools
    resources :learn_tools do
      collection do
        get :index, :featured_tool_paging, :maylike_tool_paging, 
          :first_tab_paging, :search_tool, :see_all_tool_fan, :contact_dev_form, 
          :mylearn, :tool_rev_paging, :write_review_form, :become_a_fan,
          :new_tool, :verify_handler, :owner_handler, :video_list, :video_list_paging,
          :rate, :new_tool_with_api, :choose_to_add, :edit_review_form, :delete_review,
          :play_vid, :toolmanager, :edit_tool, :delete_tool, :fan_list_paging, :view_review,
          :add_mytool, :delete_fans
        post :submit_review, :submit_new_tool, :create_tool_with_api, 
          :send_to_dev,:update_review, :save_edit_tool
      end
    end    
    
    #Settings
    resources :settings do
      collection do
        get :networks, :notifications, :language,
          :payments, :ads, :setting, :private,
          :change_psw, :save_psw, :change_name,
          :save_name, :change_user_name, :save_user_name,
					:change_email, :save_email,
          :change_time_zone, :save_time_zone, :blocks, :unblock,
					:change_school, :save_school,
					:change_chat_id, :change_chat_yahoo_id, :save_chat_id
        post :save_setting, :save_private_setting, :check_login
      end
    end
 
    #Profiles
    resources :profiles do
      collection do
        get :show_profile, :edit_infor, :edit_edu_infor,
          :edit_work_infor, :my_favorite, :fan, :delete_fans, :delete_prof
        post :update_about_yourself, :update_infor, :update_edu_infor, :update_work_infor
      end
    end
    
    #Student lounges
    resources :student_lounges do
      collection do
        get :chat, :invite_chat, :add_users_to_chat, :stop_chat, :chanel_chat_content,
          :friends_changed_message, :friends_you_invited_chat, :friends_want_you_chat, :friends_online
        post :send_data
      end
    end

    #Friends
    resources :friends do
      collection do
        get :search, :search_suggestion, :find, :find_people, :recently_added, :recently_updated,
          :friend_request, :list, :invite, :unfriend, :display_email, :add_to_group,
          :send_invite_message, :show_invite, :become_a_fan, :accept, :de_accept, :respond_to_friend_request, :get_suggestion_list
        post :find_email, :invite_by_list_email,
          :invite_by_import_email, :delete, :show_list_email_contacts,
					:find_friend_by_email
      end
    end
	
    #Stories
    resources :stories do
      collection do
        get :friend_s, :my_s, :my_draft, :draft, :create_comment, :delete_comment, :delete_all, :self_untag
        post :add_tag, :tag_decision, :remove_tagged, :comment_inform
      end
    end

    # Music Album
    resources :music_albums do
      collection do
        get :delete_all, :delete_musics, :self_untag
        post :add_tag, :tag_decision, :remove_tagged, :comment_inform
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
        get :friend_p, :my_p, :create_form, :delete_videos, :update_video, :self_untag
        post :add_tag, :tag_decision, :remove_tagged, :comment_inform
      end
    end
    
    resources :photos do
      collection do
        get :friend_p, :my_p, :create_form, :destroy_all, :show_album, :show_album_with_list, :phototag, :deletetag, :addtag, :usrdata, :self_untag
        post :create_album, :upload, :tag_decision, :remove_tagged, :comment_inform
      end
    end

    resources :u_forums do
      collection do
        get :dft_stgs, :post_lounge, :item_setting, :post_lounge_b, :rate, :friend_pad, :find_people, 
        :select_share, :page_share, :add_usr, :remove_usr, :page_member, :add_usr_show, :page_share_show, :remove_usr_show, 
        :friend_pad_show, :find_people_show, :unsubscribe, :del_cmt, :subscribe
        post :save_setting, :save_custom, :save_cmt, :save_custom_b, :remove_member, :add_more_member
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

  #Rate comment 
  resources :rate_cmts do
    collection do
      get :load_bk_like, :load_bk_dislike, :load_other
      post :add_like_cmt, :add_like_cmt
    end
  end    


  # School
  resources :schools do
    collection do
      get :state_or_city, :city
    end
  end

  # Posts
  resources :posts do
    collection do
      get :report_abuse, :create_report_abuse, :report_abuse_video, :create_report_abuse_video, :delete_comment, :download, :view_all_comments, :report_abuse_vid, :comments_list, :remove_attach_file
      post :create_comment_on_list, :create_comment
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
  
    resources :post_lecture_notes do
    collection do
      get :search, :due_date, :interesting, :tag, :quick_post_form
    end
  end
  
  #Ajax not login
  resources :ajax_not_login do
    collection do
      get :show_comment, :rate_comment, :rate_comment_action, :view_results, :view_press_info_detail, :view_career_detail
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
  
  #Forums
  resources :forums do 
    collection do
      get :delcmt, :search, :see_all_top_fr, :view_all_comments, :view_all_no_loggin, :delfrm, :view_fr
      post :addfr, :save_edit, :savecmt
    end
  end
  
  #Press infos
  resources :press_infos do
    collection do
      get :view_pr, :view_detail, :delpr, :searchpr
      post :save
    end
  end
  
  #Careers
  resources :careers do
    collection do
      get :view_pr, :view_detail, :delpr, :searchpr
      post :save
    end
  end
  
  # OAuth
  resources :oauth_clients do
    collection do
      get :new_from_tool, :tab_paging, :edit_tool, :delete_tool, :show_tool, :edit_tool_no_api
      post :save_edit_tool, :save_edit_no_api
    end
  end
  
  match '/oauth/test_request',  :to => 'oauth#test_request',  :as => :test_request

  match '/oauth/token',         :to => 'oauth#token',         :as => :token

  match '/oauth/access_token',  :to => 'oauth#access_token',  :as => :access_token

  match '/oauth/request_token', :to => 'oauth#request_token', :as => :request_token

  match '/oauth/authorize',     :to => 'oauth#authorize',     :as => :authorize

  match '/oauth',               :to => 'oauth#index',         :as => :oauth
  
	# Omniauth
	resources :omnitauths
	match '/auth/:provider/callback' => 'omnitauths#create'

  # Dashboard as the default location
  root :to => 'dashboards#index'

  # Install the default routes as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'
end
