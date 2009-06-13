# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  
  # Validations
  validates_presence_of :login, :if => :not_using_openid?
  validates_length_of :login, :within => 3..40, :if => :not_using_openid?
  validates_uniqueness_of :login, :case_sensitive => false, :if => :not_using_openid?
  validates_format_of :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :if => :not_using_openid?
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email, :if => :not_using_openid?
  validates_length_of :email, :within => 6..100, :if => :not_using_openid?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :not_using_openid?
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?
  validates_uniqueness_of :identity_url, :unless => :not_using_openid?
  validate :normalize_identity_url

  # Relations
  belongs_to :school
  has_and_belongs_to_many :roles
  has_many :posts, :dependent => :destroy
  has_one :user_information, :dependent => :destroy
  has_one :user_education, :dependent => :destroy
  has_one :user_employment, :dependent => :destroy
  has_many :stories, :dependent => :destroy
  has_many :photo_albums, :dependent => :destroy
  has_many :music_albums, :dependent => :destroy
  has_many :video_albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :musics, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_many :users_can_see_photos, :dependent => :destroy
  has_many :users_can_see_musics, :dependent => :destroy
  has_many :users_can_see_videos, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
	has_many :flirting_chanels, :dependent => :destroy
	has_many :flirting_messages, :dependent => :destroy
	has_many :flirting_sharrings, :dependent => :destroy

  # Acts_as_network
  acts_as_network :user_friends, :through => :user_invites, :conditions => ["is_accepted = ?", true]

  # Active tracker
  tracks_unlinked_activities [:updated_profile, :updated_avatar]

  # Comments
  acts_as_commentable
  
  # Rating
  ajaxful_rater

  # Message
  has_private_messages
  
  # Avatar
  has_attached_file :avatar,
    :default_url => "/images/missing_:style_avatar.gif",
    :styles => { :medium => "300x300>",
    :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
  
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

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def not_using_openid?
    identity_url.blank?
  end
  
  def password_required?
    new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?) : !password.blank?
  end

  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_url(identity_url) unless not_using_openid?
  rescue
    errors.add_to_base("Invalid OpenID URL")
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
      state === "active"
      any{login =~ "%#{user_name}%"; name =~ "%#{user_name}%"} if user_name
      login! === ['admin']
    end
    User.find :all, :conditions => cond.to_sql(), :order => "activated_at DESC"
  end

  def full_name
    self.name == "" ? self.login : self.name
  end
	
	def check_user_in_chatting_session(user_id)
		cond = Caboose::EZ::Condition.new :flirting_chanels do
      status === "Chat"
      any{user_id === "#{self.id}"; user_id_target === "#{user_id}"}
    end
		flirting_chanels = FlirtingChanel.find :all, :conditions => cond.to_sql()
		if flirting_chanels.size > 0 then
			return true
		else
			return false
		end
	end
	
	def friends_change_message
		return FlirtingMessage.find :all, :include => :flirting_chanel, :conditions => "flirting_chanel_id IN (Select id From flirting_chanels where status = 'Chat' And (user_id = #{self.id} Or user_id_target = #{self.id}))"
	end
	
	def friends_want_chat
		return FlirtingChanel.find_all_by_user_id_target_and_status(self.id, "Invite")
	end
	
	def friends_invite_chat
		return FlirtingChanel.find_all_by_user_id_and_status(self.id, "Invite")
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
