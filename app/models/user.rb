# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'digest/sha1'
require 'open-uri'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  include ApplicationHelper

  # Validations
  validates_presence_of :login
  validates_format_of :name, :with => Authentication.name_regex, :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email
  validates_length_of :email, :within => 6..100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_presence_of :school_id
  
  # Relations
  belongs_to :school
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :friend_shares, :class_name => "Share"
  has_one :user_information, :dependent => :destroy
  has_one :user_education, :dependent => :destroy
  has_one :user_employment, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :selling_items, :dependent => :destroy
  has_many :stories, :dependent => :destroy
  has_many :photo_albums, :dependent => :destroy
  has_many :music_albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :musics, :dependent => :destroy
  has_many :videos, :dependent => :destroy, :conditions => ["state = 'converted'"]
  has_many :favorites, :dependent => :destroy
  has_many :flirting_messages, :dependent => :destroy
  has_many :flirting_sharrings, :dependent => :destroy
  has_many :flirting_user_inchats, :dependent => :destroy
  has_many :notify_sms_settings, :dependent => :destroy
  has_many :notify_email_settings, :dependent => :destroy
  has_many :user_walls, :dependent => :destroy
  has_many :friend_in_groups, :dependent => :destroy
  has_many :jobs_lists, :dependent => :destroy
  has_many :partys_lists, :dependent => :destroy
  has_many :post_awarenesses_supports, :dependent => :destroy
  has_many :my_shares, :class_name => "Share", :foreign_key => "sender_id"
  has_many :private_settings
  has_many :forums, :dependent => :destroy
  has_many :press_infos, :dependent => :destroy
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken", :order=>"authorized_at desc", :include=>[:client_application]
  has_many :learntools, :dependent => :destroy
  has_many :my_tools, :dependent => :destroy
  has_many :tool_reviews, :dependent => :destroy
	has_many :user_blocks, :dependent => :destroy
	has_many :user_wall_blocks, :dependent => :destroy
	has_many :user_wall_follows, :dependent => :destroy
	has_many :user_wall_posts, :through => :user_walls
	has_many :user_id_chats, :dependent => :destroy
  has_many :ufos, :dependent => :destroy
  has_many :ufo_cmts, :dependent => :destroy
  has_one :ufo_default, :dependent => :destroy
  has_many :ufo_members, :dependent => :destroy
	has_many :omnitauths
  
  # Acts_as_network
  acts_as_network :user_friends, :through => :user_invites, :conditions => ["is_accepted = ?", true]
  
  # Acts_as_fannable
  acts_as_fannable
  
  # Active tracker
  tracks_unlinked_activities [:updated_profile, :updated_avatar]
  
  # Comments
  acts_as_commentable
  
  # Favorite
  acts_as_favorite_user
  
  
  # Message
  has_private_messages
  
  # Avatar
  has_attached_file :avatar, {
    :bucket => 'afterclassroom_avatar',
    :default_url => "/images/icons/icon_defaut/icon_members.png",
    :styles => { :medium => "169x169>",
      :thumb => "45x45#" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  # process_in_background :avatar
  
  validates_attachment_content_type :avatar, :content_type => ['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png']
  
  # Squeezes spaces inside the string: "James   Bond  " => "James Bond"
  auto_strip_attributes :name, :squish => true
  
  # Won't set to null even if string is blank. "   " => ""
  auto_strip_attributes :email, :nullify => false
  
  # Friendly ID
  extend FriendlyId
  friendly_id :login, :use => :slugged
  
  # Solr search index
  searchable :auto_index => true, :auto_remove => true do
    text :name, :default_boost => 2, :stored => true
    text :email, :stored => true
    time :created_at
  end
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :school_id, :allow_search_by_email, :time_zone, :created_at
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role)
    list ||= self.roles.collect(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_in_state :first, :active, :conditions => {:email => email} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def password_required?
    new_record? ? (crypted_password.blank? || !password.blank?) : !password.blank?
  end
  
  # Creates a new password for the user, and notifies him with an email
  def reset_password!
    password = PasswordGenerator.random_pronouncable_password(3)
    self.password = password
    self.password_confirmation = password
    self.password_reset_code = nil
    save
    
    UserMailer.deliver_reset_password(self)
  end
  
  def forgot_password
    self.make_password_reset_code
    save
    UserMailer.deliver_forgot_password(self)
  end
  
  def self.find_by_login_or_email(login_or_email)
    find(:first, :conditions => ['login = ? OR email = ?', login_or_email, login_or_email])
  rescue
    nil
  end
  
  def self.paginated_users_conditions_with_search(params)
    user_name = params[:search][:name] if params[:search]
    cond = Caboose::EZ::Condition.new :users do
      state == "active"
      any{name =~ "%#{user_name}%"; email =~ "%#{user_name}%"} if user_name
      login! === ['admin']
    end
    User.find :all, :conditions => cond.to_sql(), :order => "activated_at DESC"
  end
  
  def full_name
    self.name == "" ? self.login : self.name
  end
  
  def self.get_online_users
    User.where(:online => true)
  end
  
  def check_user_online
    self.online
  end
  
  def check_user_in_chatting_session(user_id)
    flirting_user_inchats = FlirtingUserInchat.find :all, :conditions => "(user_id = #{self.id} And user_id_invite = #{user_id}) Or (user_id = #{user_id} And user_id_invite = #{self.id})"
    if flirting_user_inchats.size > 0 then
      return true
    else
      return false
    end
  end
  
  def check_user_in_chat(v_user_id)
    cond = Caboose::EZ::Condition.new :flirting_user_inchats do
      status == "Chat"
      any{ user_id == v_user_id; user_id_invite == v_user_id }
    end
    flirting_user_inchats = FlirtingUserInchat.find :all, :conditions => cond.to_sql()
    if flirting_user_inchats.size > 0 then
      return true
    else
      return false
    end
  end
  
  def check_user_is_invited(v_user_id)
    cond = Caboose::EZ::Condition.new :flirting_user_inchats do
      status == "Invite"
      any{ user_id == v_user_id; user_id_invite == v_user_id }
    end
    flirting_user_inchats = FlirtingUserInchat.find :all, :conditions => cond.to_sql()
    if flirting_user_inchats.size > 0 then
      return true
    else
      return false
    end
  end	
  
  def check_user_in_chanel(v_user_id, v_chanel_id)
    cond = Caboose::EZ::Condition.new :flirting_user_inchats do
      flirting_chanel_id == v_chanel_id
      any{ user_id == v_user_id; user_id_invite == v_user_id }
    end
    flirting_user_inchats = FlirtingUserInchat.find :all, :include => :flirting_chanel, :conditions => cond.to_sql()
    if flirting_user_inchats.size > 0 then
      return true
    else
      return false
    end
  end
  
  def friends_change_message
    v_user_id = self.id
    cond = Caboose::EZ::Condition.new :flirting_user_inchats do
      status == "Chat"
      any{ user_id == v_user_id; user_id_invite == v_user_id }
    end
    friends_change = FlirtingUserInchat.find :all, :conditions => cond.to_sql, :order => "created_at DESC"
    return friends_change
  end
  
  def friends_want_chat
    friends_want = FlirtingUserInchat.find_all_by_user_id_and_status(self.id, "Invite")
    return friends_want
  end
  
  def friends_invite_chat
    friends_invite = FlirtingUserInchat.find_all_by_user_id_invite_and_status(self.id, "Invite")
    return friends_invite
  end
  
  def friends_with_chanel(chanel_id)
    friends = []
    for friend in self.user_friends
      friends << friend if !check_user_in_chanel(friend.id, chanel_id)
    end
    return friends
  end
  
  def friends_in_chat
    friends = []
    for friend in self.user_friends
      friends << friend if check_user_in_chat(friend.id)
    end
    return friends
  end
  
  def friends_online
    friends = []
    for friend in self.user_friends
      friends << friend if friend.online
    end
    return friends
  end
  
  def has_role?(role)
    list ||= self.roles.collect(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  def my_walls
		user_id_blocks = self.user_blocks.map(&:user_id_block)
		user_wall_id_blocks = self.user_wall_blocks.map(&:user_wall_id)
		user_wall_id_follows = []
		self.user_wall_follows.each do |f|
			user_wall_id_follows << f.user_wall_id if check_private_permission(self, f.user_wall.user, "my_lounges")
		end
		user_wall_ids = user_wall_id_follows - user_wall_id_blocks
		str_cond = "user_id_post = #{self.id} OR user_id = #{self.id}"
		str_cond = str_cond + " AND user_id NOT IN('#{user_id_blocks.join("', '")}')" if user_id_blocks.size > 0
		str_cond = str_cond + " AND id NOT IN('#{user_wall_id_blocks.join("', '")}')" if user_wall_id_blocks.size > 0
		str_cond = str_cond + " OR id IN('#{user_wall_ids.join("', '")}')" if user_wall_ids.size > 0		
		UserWall.where(str_cond).order("updated_at DESC")
  end
  
  def fans_recent_update
    self.fans.find(:all, :order => "updated_at DESC")
  end
  
  def get_posts_with_type_and_sort(type, sort)
    if type != ""
      self.posts.find(:all, :conditions => ["type_name = ?", type], :order => "created_at #{sort}")
    else
      self.posts.find(:all, :order => "created_at #{sort}")
    end
  end
  
  def get_posts_with_type(type)
    self.posts.find(:all, :conditions => ["type_name = ?", type])
  end
  
  def get_total_posts_with_type(type)
    get_posts_with_type(type).size
  end
  
  def friend_of_friends
    fof = []
    self.user_friends.each do |f|
      fof = fof + f.user_friends
    end
    fof = fof + self.user_friends
		fof = fof.uniq
  end
  
  def set_time_zone_from_ip(ip)
		begin
			location = open("http://api.hostip.info/get_html.php?ip=#{ip}&position=true")
		  if location.string =~ /Latitude: (.+?)\nLongitude: (.+?)\n/
		    timezone = Geonames::WebService.timezone($1, $2)
		    
		    self.time_zone = ActiveSupport::TimeZone::MAPPING.index(timezone.timezone_id) unless timezone.nil?
		  end
		rescue
			# Nothing
		end
  end
  
  def suggestions
		suggest_ids = []
		limit_suggestion = 10
    friend_ids = self.user_friends.map(&:id)
    fofs = self.friend_of_friends.map(&:id)
    invite_out_ids = self.user_invites_out.where("is_accepted IS NULL").map(&:user_id_target)
    invite_in_ids = self.user_invites_in.where("is_accepted IS NULL").map(&:user_id)
    suggest_ids = fofs - friend_ids - invite_out_ids - invite_in_ids - [self.id]
		people_ids = friend_ids + invite_out_ids + invite_in_ids + [self.id]
    if suggest_ids.size > 0
      fofs_suggestion = User.find(:all, :limit => limit_suggestion, :conditions => ["id IN(#{suggest_ids.join(',')}) AND state='active'"], :order => "RAND()")
			if fofs_suggestion.size == limit_suggestion
				return fofs_suggestion
			else
				people_suggestion = User.find(:all, :limit => (limit_suggestion - fofs_suggestion.size), :conditions => ["id NOT IN(#{people_ids.join(',')}) AND state='active'"], :order => "RAND()")
				return fofs_suggestion + people_suggestion
			end
    else
      return User.find(:all, :limit => limit_suggestion, :conditions => ["id NOT IN(#{people_ids.join(',')}) AND state='active'"], :order => "RAND()")
    end
  end
  
  def walls_with_setting
    user_ids = [] 
		user_id_blocks = self.user_blocks.map(&:user_id_block)
		user_wall_id_blocks = self.user_wall_blocks.map(&:user_wall_id)
    self.user_friends.each do |f|
      user_ids << f.id if check_private_permission(self, f, "my_lounges")
    end
		user_id_posts = user_ids - user_id_blocks
		str_cond = ""
		if user_id_posts.size > 0
			user_wall_follows = UserWallFollow.where("user_id IN('#{user_id_posts.join("', '")}')")
			if user_id_blocks.size > 0
				user_wall_id_follows = user_wall_follows.collect{|i| i.user_wall_id if !user_id_blocks.include?(i.user_wall.user_id_post)  }
			else
				user_wall_id_follows = user_wall_follows.map(&:user_wall_id)
			end
			user_wall_ids = user_wall_id_follows - user_wall_id_blocks
			str_cond << "user_id_post IN('#{user_id_posts.join("', '")}')"
			str_cond << " AND id NOT IN('#{user_wall_id_blocks.join("', '")}')" if user_wall_id_blocks.size > 0
			str_cond << " OR id IN('#{user_wall_ids.join("', '")}')" if user_wall_ids.size > 0
		end
		return str_cond == "" ? [] : UserWall.where(str_cond).order("updated_at DESC")
  end

	def videos_same_category(video)
		self.videos.where("category = '#{video.category}'")
	end

  def self.delete_data_user_demo
    user_demo = User.find_by_email("demotoyou@gmail.com")
		if user_demo
			user_demo.posts.destroy_all
			user_demo.stories.destroy_all
			user_demo.photo_albums.destroy_all
			user_demo.music_albums.destroy_all
			user_demo.photos.destroy_all
			user_demo.musics.destroy_all
			user_demo.videos.destroy_all
			user_demo.favorites.destroy_all
			user_demo.user_walls.destroy_all
			user_demo.jobs_lists.destroy_all
			user_demo.partys_lists.destroy_all
			user_demo.my_shares.destroy_all
			user_demo.forums.destroy_all
			user_demo.learntools.destroy_all
			user_demo.my_tools.destroy_all
  		user_demo.tool_reviews.destroy_all
			user_demo.user_blocks.destroy_all
			user_demo.user_wall_blocks.destroy_all
			user_demo.user_wall_follows.destroy_all
			user_demo.user_wall_posts.destroy_all
  		user_demo.ufos.destroy_all
  		user_demo.ufo_cmts.destroy_all
  		user_demo.ufo_default.destroy
  		user_demo.ufo_members.destroy_all
		end
  end
  
  protected
  
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
  def make_password_reset_code
    self.password_reset_code = self.class.make_token
  end
  
end
