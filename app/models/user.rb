# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  
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
  has_one :user_information, :dependent => :destroy
  has_one :user_education, :dependent => :destroy
  has_one :user_employment, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :selling_items, :dependent => :destroy
  has_many :stories, :dependent => :destroy
  has_many :photo_albums, :dependent => :destroy
  has_many :music_albums, :dependent => :destroy
  has_many :video_albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :musics, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
	has_many :flirting_messages, :dependent => :destroy
	has_many :flirting_sharrings, :dependent => :destroy
	has_many :flirting_user_inchats, :dependent => :destroy
  has_many :notify_sms_settings
  has_many :notify_email_settings
  has_many :user_walls, :dependent => :destroy
  has_many :friend_in_groups, :dependent => :destroy
  has_many :jobs_lists, :dependent => :destroy
  has_many :partys_lists, :dependent => :destroy
  has_many :post_awarenesses_supports, :dependent => :destroy

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

  # Taggable
  acts_as_tagger
    
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/gif', 'image/png']

  # ThinkSphinx
  define_index do
    indexes name, :sortable => true
    indexes email
    has school_id, created_at
  end
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :school_id, :allow_search_by_email
  
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
      any{login =~ "%#{user_name}%"; name =~ "%#{user_name}%"} if user_name
      login! === ['admin']
    end
    User.find :all, :conditions => cond.to_sql(), :order => "activated_at DESC"
  end

  def full_name
    self.name == "" ? self.login : self.name
  end

  def self.get_online_users
    sessions = ActiveRecord::SessionStore::Session.find(:all, :conditions => ["updated_at >= ?", 30.minutes.ago])
    user_ids = sessions.collect{|s| s.data["user_id"]}.compact.uniq

    online_users = User.find(user_ids)
    return online_users
  end

	def check_user_online
		check = false
		online_users = User.get_online_users
		check = online_users.include?(self)
		return check
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

  def has_role?(role)
    list ||= self.roles.collect(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end

  def my_walls
    UserWall.find(:all, :conditions => ["user_id_post = ?", self.id], :order => "created_at DESC")
  end
  
  def fans_recent_update
    over = 30
    self.fans.find(:all, :conditions => ["updated_at > ?", Time.now - over.day], :order => "updated_at DESC")
  end

  def fans_not_visit
    over = 30
    self.fans.find(:all, :conditions => ["updated_at < ?", Time.now - over.day], :order => "updated_at DESC")
  end

  def get_posts_with_type(type)
    self.posts.find(:all, :conditions => ["type_name = ?", type], :order => "updated_at DESC")
  end

  def get_total_posts_with_type(type)
    get_posts_with_type(type).size
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
