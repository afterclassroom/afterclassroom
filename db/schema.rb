# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110727035254) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action",     :limit => 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  create_table "awareness_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "book_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "cities", :force => true do |t|
    t.string  "name",       :limit => 100, :null => false
    t.integer "state_id",                  :null => false
    t.integer "country_id",                :null => false
  end

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 40
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "countries", :force => true do |t|
    t.string  "iso"
    t.string  "name"
    t.string  "printable_name"
    t.string  "iso3"
    t.integer "numcode"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "department_categories", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "departments", :force => true do |t|
    t.integer "department_category_id", :null => false
    t.string  "name",                   :null => false
  end

  create_table "departments_schools", :id => false, :force => true do |t|
    t.integer "school_id",     :null => false
    t.integer "department_id", :null => false
  end

  create_table "event_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "fans", :force => true do |t|
    t.integer  "fannable_id",   :default => 0,  :null => false
    t.string   "fannable_type", :default => "", :null => false
    t.integer  "user_id",       :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fans", ["user_id"], :name => "fk_fans_user"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.string   "favorable_type", :limit => 30
    t.integer  "favorable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "subject"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flirting_chanels", :force => true do |t|
    t.string   "chanel_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flirting_messages", :force => true do |t|
    t.integer  "flirting_chanel_id"
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "notify_msg",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flirting_sharrings", :force => true do |t|
    t.integer "flirting_chanel_id"
    t.integer "user_id"
    t.string  "sharring_type"
    t.integer "sharring_id"
    t.boolean "accepted"
  end

  create_table "flirting_user_inchats", :force => true do |t|
    t.integer  "flirting_chanel_id"
    t.integer  "user_id"
    t.integer  "user_id_invite"
    t.string   "status",             :default => "Invite"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_groups", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "friend_in_groups", :force => true do |t|
    t.integer "friend_group_id", :null => false
    t.integer "user_id",         :null => false
    t.integer "user_id_friend",  :null => false
  end

  create_table "friend_invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "invitation_code"
    t.integer  "became_user_id"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "housing_categories", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "housing_categories_post_housings", :id => false, :force => true do |t|
    t.integer "housing_category_id", :null => false
    t.integer "post_housing_id",     :null => false
  end

  create_table "ip_countries", :force => true do |t|
    t.string "ip_address"
    t.string "ip_code"
    t.string "country"
    t.string "state"
    t.string "city"
  end

  create_table "job_files", :force => true do |t|
    t.string   "category"
    t.integer  "post_job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resume_cv_file_name"
    t.string   "resume_cv_content_type"
    t.integer  "resume_cv_file_size"
  end

  create_table "job_infors", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

  create_table "job_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "jobs_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learn_tool_cates", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learntools", :force => true do |t|
<<<<<<< HEAD
    t.integer  "user_id",     :null => false
=======
    t.integer  "user_id",               :null => false
    t.integer  "learn_tool_cate_id",    :null => false
>>>>>>> 31594298211c08a2346bc8ccd35bc61693762d0c
    t.string   "name"
    t.text     "description"
    t.boolean  "verify"
    t.boolean  "authorize"
    t.text     "href"
    t.integer  "acc_play_no"
    t.integer  "client_application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_albums", :force => true do |t|
    t.integer  "user_id",                                        :null => false
    t.string   "name",                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "music_album_attach_file_name"
    t.string   "music_album_attach_content_type"
    t.integer  "music_album_attach_file_size"
    t.datetime "music_album_attach_updated_at"
    t.integer  "count_view",                      :default => 0, :null => false
  end

  create_table "musics", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "music_album_id",                           :null => false
    t.string   "title"
    t.string   "artist"
    t.integer  "length_in_seconds"
    t.integer  "count_view",                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "music_attach_file_name"
    t.string   "music_attach_content_type"
    t.integer  "music_attach_file_size"
    t.datetime "music_attach_updated_at"
  end

  create_table "my_statistics", :force => true do |t|
    t.integer "rated_id"
    t.string  "rated_type"
    t.integer "rating_count"
    t.decimal "rating_total", :precision => 10, :scale => 0
    t.decimal "rating_avg",   :precision => 10, :scale => 2
  end

  add_index "my_statistics", ["rated_type", "rated_id"], :name => "index_my_statistics_on_rated_type_and_rated_id"

  create_table "my_stats_ratings", :force => true do |t|
    t.integer "rater_id"
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating",     :precision => 10, :scale => 0
  end

  add_index "my_stats_ratings", ["rated_type", "rated_id"], :name => "index_my_stats_ratings_on_rated_type_and_rated_id"
  add_index "my_stats_ratings", ["rater_id"], :name => "index_my_stats_ratings_on_rater_id"

  create_table "no_rater_ratings", :force => true do |t|
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating",     :precision => 10, :scale => 0
  end

  add_index "no_rater_ratings", ["rated_type", "rated_id"], :name => "index_no_rater_ratings_on_rated_type_and_rated_id"

  create_table "notifications", :force => true do |t|
    t.boolean  "sms_allow"
    t.boolean  "email_allow"
    t.string   "name"
    t.string   "label"
    t.string   "notify_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notify_email_settings", :force => true do |t|
    t.integer "user_id"
    t.integer "notification_id"
  end

  create_table "notify_sms_settings", :force => true do |t|
    t.integer "user_id"
    t.integer "notification_id"
  end

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 40
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.string   "scope"
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "party_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "party_types_post_parties", :id => false, :force => true do |t|
    t.integer "post_party_id", :null => false
    t.integer "party_type_id", :null => false
  end

  create_table "partys_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_albums", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.string   "name",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count_view", :default => 0, :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "photo_album_id",                           :null => false
    t.string   "title"
    t.text     "description"
    t.integer  "count_view",                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_attach_file_name"
    t.string   "photo_attach_content_type"
    t.integer  "photo_attach_file_size"
    t.datetime "photo_attach_updated_at"
  end

  create_table "post_assignments", :force => true do |t|
    t.integer  "post_id"
    t.string   "professor"
    t.datetime "due_date"
  end

  create_table "post_awarenesses", :force => true do |t|
    t.integer  "post_id",           :null => false
    t.integer  "awareness_type_id"
    t.datetime "due_date"
    t.string   "phone"
    t.string   "rating_status"
  end

  create_table "post_awarenesses_supports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_awareness_id"
    t.boolean  "support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_books", :force => true do |t|
    t.integer "post_id",       :null => false
    t.integer "book_type_id"
    t.string  "address"
    t.string  "phone"
    t.string  "price"
    t.string  "rating_status"
  end

  create_table "post_categories", :force => true do |t|
    t.string "name",       :null => false
    t.string "class_name", :null => false
  end

  create_table "post_events", :force => true do |t|
    t.integer  "post_id"
    t.integer  "event_type_id"
    t.string   "address"
    t.string   "phone"
    t.string   "rating_status"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "post_exam_schedules", :force => true do |t|
    t.integer  "post_id"
    t.string   "teacher_name"
    t.datetime "due_date"
    t.datetime "starts_at"
    t.string   "place"
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_exams", :force => true do |t|
    t.integer  "post_id"
    t.integer  "department_id"
    t.string   "school_year"
    t.datetime "due_date"
  end

  create_table "post_foods", :force => true do |t|
    t.integer "post_id"
    t.string  "address"
    t.string  "phone"
    t.string  "rating_status"
  end

  create_table "post_housings", :force => true do |t|
    t.integer "post_id",       :null => false
    t.string  "rent"
    t.string  "currency"
    t.string  "address"
    t.string  "phone"
    t.string  "rating_status"
  end

  create_table "post_jobs", :force => true do |t|
    t.integer "post_id",                :null => false
    t.integer "job_type_id"
    t.string  "address"
    t.string  "phone"
    t.boolean "prepare_post"
    t.text    "responsibilities"
    t.text    "required_skills"
    t.text    "desirable_skills"
    t.text    "edu_experience_require"
    t.string  "compensation"
    t.string  "rating_status"
  end

  create_table "post_myxes", :force => true do |t|
    t.integer "post_id"
    t.string  "professor"
    t.string  "rating_status"
  end

  create_table "post_parties", :force => true do |t|
    t.integer  "post_id",       :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "address"
    t.string   "phone"
    t.string   "rating_status"
  end

  create_table "post_party_rsvps", :force => true do |t|
    t.integer  "post_party_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "tel"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_projects", :force => true do |t|
    t.integer  "post_id"
    t.datetime "due_date"
  end

  create_table "post_qa_categories", :force => true do |t|
    t.string "name"
  end

  create_table "post_qas", :force => true do |t|
    t.integer "post_id"
    t.integer "post_qa_category_id"
    t.string  "rating_status"
  end

  create_table "post_teamups", :force => true do |t|
    t.integer "post_id",            :null => false
    t.integer "teamup_category_id", :null => false
    t.string  "rating_status"
  end

  create_table "post_tests", :force => true do |t|
    t.integer  "post_id"
    t.datetime "due_date"
  end

  create_table "post_tutors", :force => true do |t|
    t.integer "post_id"
    t.integer "tutor_type_id"
    t.string  "address"
    t.string  "phone"
    t.string  "rating_status"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                                :null => false
    t.integer  "post_category_id"
    t.integer  "school_id",                              :null => false
    t.integer  "department_id"
    t.string   "school_year"
    t.string   "title",                                  :null => false
    t.text     "description",                            :null => false
    t.boolean  "use_this_email",      :default => false
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.integer  "count_view",          :default => 0
    t.boolean  "delta",               :default => true,  :null => false
  end

  create_table "press_infos", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "type_setting"
    t.integer  "share_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "post_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["post_id"], :name => "index_rates_on_post_id"
  add_index "rates", ["rateable_id"], :name => "index_rates_on_rateable_id"

  create_table "rating_statistics", :force => true do |t|
    t.integer "rated_id"
    t.string  "rated_type"
    t.integer "rating_count"
    t.decimal "rating_total", :precision => 10, :scale => 0
    t.decimal "rating_avg",   :precision => 10, :scale => 2
  end

  add_index "rating_statistics", ["rated_type", "rated_id"], :name => "index_rating_statistics_on_rated_type_and_rated_id"

  create_table "ratings", :force => true do |t|
    t.integer "rater_id"
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating",     :precision => 10, :scale => 0
  end

  add_index "ratings", ["rated_type", "rated_id"], :name => "index_ratings_on_rated_type_and_rated_id"
  add_index "ratings", ["rater_id"], :name => "index_ratings_on_rater_id"

  create_table "report_abuse_categories", :force => true do |t|
    t.string "name"
  end

  create_table "report_abuses", :force => true do |t|
    t.integer  "report_abuse_category_id"
    t.integer  "reporter_id"
    t.integer  "reported_id"
    t.string   "reported_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "schools", :force => true do |t|
    t.string  "name",        :null => false
    t.integer "city_id",     :null => false
    t.string  "type_school", :null => false
    t.string  "website"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "label"
    t.string   "identifier"
    t.text     "description"
    t.string   "field_type",  :default => "string"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shares", :force => true do |t|
    t.integer  "sender_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

  create_table "shares_users", :id => false, :force => true do |t|
    t.integer "share_id"
    t.integer "user_id"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "states", :force => true do |t|
    t.integer "country_id",               :null => false
    t.string  "name",       :limit => 50, :null => false
    t.string  "alias",      :limit => 10, :null => false
  end

  create_table "stats_ratings", :force => true do |t|
    t.integer "rater_id"
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating",     :precision => 10, :scale => 0
  end

  add_index "stats_ratings", ["rated_type", "rated_id"], :name => "index_stats_ratings_on_rated_type_and_rated_id"
  add_index "stats_ratings", ["rater_id"], :name => "index_stats_ratings_on_rater_id"

  create_table "stories", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.string   "title",                     :null => false
    t.text     "content"
    t.integer  "count_view", :default => 0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teamup_categories", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "tutor_types", :force => true do |t|
    t.string "name"
    t.string "label"
  end

  create_table "user_educations", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "grad_school"
    t.string   "college"
    t.string   "high_school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_employments", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.string   "current_employer"
    t.string   "position_current"
    t.string   "time_period"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_informations", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.string   "current_city"
    t.text     "looking_for"
    t.boolean  "sex"
    t.date     "birthday"
    t.string   "mobile_number"
    t.string   "website"
    t.string   "relationship_status"
    t.text     "polictical_view"
    t.string   "about_yourself"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_invites", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "user_id_target", :null => false
    t.string   "code"
    t.text     "message"
    t.boolean  "is_accepted"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_wall_links", :force => true do |t|
    t.integer "user_wall_id"
    t.string  "link"
    t.string  "image_link"
    t.string  "title"
    t.text    "sub_content"
  end

  create_table "user_wall_musics", :force => true do |t|
    t.integer "user_wall_id"
    t.string  "link"
    t.string  "title"
    t.text    "sub_content"
  end

  create_table "user_wall_photos", :force => true do |t|
    t.integer "user_wall_id"
    t.string  "link"
    t.string  "title"
    t.text    "sub_content"
  end

  create_table "user_wall_videos", :force => true do |t|
    t.integer "user_wall_id"
    t.string  "link"
    t.string  "thumb"
    t.string  "title"
    t.text    "sub_content"
  end

  create_table "user_walls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_id_post"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "identity_url"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive"
    t.datetime "remember_token_expires_at"
    t.string   "password_reset_code"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.boolean  "allow_search_by_email"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "online",                                   :default => false
    t.boolean  "delta",                                    :default => true,      :null => false
    t.string   "time_zone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "video_albums", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_files", :force => true do |t|
    t.integer  "video_id",                  :null => false
    t.string   "video_attach_file_name"
    t.string   "video_attach_content_type"
    t.integer  "video_attach_file_size"
    t.datetime "video_attach_updated_at"
  end

  create_table "videos", :force => true do |t|
<<<<<<< HEAD
    t.integer  "user_id",                                                 :null => false
    t.integer  "video_album_id",                                          :null => false
    t.string   "title"
    t.text     "description"
    t.integer  "who_can_see",                              :default => 0
=======
    t.integer  "user_id",                                  :null => false
    t.integer  "video_album_id",                           :null => false
    t.string   "title"
    t.text     "description"
    t.integer  "who_can_see",               :default => 0
>>>>>>> 31594298211c08a2346bc8ccd35bc61693762d0c
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_attach_file_name"
    t.string   "video_attach_content_type"
    t.integer  "video_attach_file_size"
    t.datetime "video_attach_updated_at"
<<<<<<< HEAD
    t.integer  "count_view",                               :default => 0, :null => false
    t.string   "state",                     :limit => 225
=======
>>>>>>> 31594298211c08a2346bc8ccd35bc61693762d0c
  end

end
