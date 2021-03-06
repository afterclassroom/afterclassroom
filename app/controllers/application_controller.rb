# encoding: UTF-8
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  include Viewable
  include Notify
  include Postwall
  include SimpleCaptcha::ControllerHelpers
	include UpdateUserWallFollow
  
  helper :all # include all helpers, all the time
  #config.filter_parameters :password, :password_confirmation
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '9fe6825f97cc334d88925fde5c4808a8'
  
  # Temp
  USER_NAME, PASSWORD = "afterclassroom", "teamwork"
  
  before_filter :authenticate
  before_filter :set_user_time_zone
  
  def help
    Helper.instance
  end
  
  class Helper
    include Singleton
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::RawOutputHelper
  end
  
  def object_with_type(type, id)
    item = nil
    case type
      when "Post"
      item = Post.find(id)
      when "Story"
      item = Story.find(id)
      when "PhotoAlbum"
      item = PhotoAlbum.find(id)
      when "Photo"
      item = Photo.find(id)
      when "MusicAlbum"
      item = MusicAlbum.find(id)
      when "Music"
      item = Music.find(id)
      when "Video"
      item = Video.find(id)
    end
    return item
  end
  
  def to_slug(str)
    #strip the string
    ret = str.strip
    
    #blow away apostrophes
    ret.gsub! /['`]/,""
    
    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "
    
    #replace all non alphanumeric, underscore or periods with underscore
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'
    
    #convert double underscores to single
    ret.gsub! /_+/,"_"
    
    #strip off leading/trailing underscore
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""
    
    ret
  end
  
  def cas_user
    # Get ticket
    path = request.fullpath
    arr = path.split("ticket=")
    if arr.length > 1
      session[:ticket] = arr[1]
    end
    if session[:cas_user] and self.current_user == nil
      self.current_user = User.find_by_email(session[:cas_user])
      self.current_user.update_attribute("online", true)
      self.current_user.set_time_zone_from_ip(request.remote_ip)
      # Set session your school
      session[:your_school] = self.current_user.school.id
			session[:your_school_type] = self.current_user.school.type_school
			if self.current_user.email == "demotoyou@gmail.com"
				redirect_to path	
			else
				redirect_to user_student_lounges_path(self.current_user)
			end
    end
  end
  
  def get_comments(post, show)
    @comments = []
    case show
      when "0"
      @comments = post.comments
      when "1"
      @comments = post.comments
      when "2"
      @comments = post.comments.find(:all, :order => "created_at DESC")
      when "3"
      arr_comnt = []
      post.comments.each do |c|
        arr_comnt << {:obj => c, :total_good => c.total_good}
      end
      arr_comnt.sort_by { |c| -c[:total_good] }.each do |d|
        @comments << d[:obj]
      end
    end
  end
  
  def delete_favorite(type, id)
    Favorite.destroy_all(["favorable_type = ? AND favorable_id = ?", type, id])
  end
  
	def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
	end
	
	def delayed_job_admin_authentication
      # authentication_logic_goes_here
  end

	def update_wall(comnd)
		post_type = comnd.commentable_type
		post_id = comnd.commentable_id
		if post_type == "Post"
			post = Post.find(post_id)
			if post
				post_type = post.type_name 
				post_id = eval(post_type).find_by_post_id(post_id).id
			end
		end
		user_wall_post = UserWallPost.find_by_post_type_and_post_id(post_type, post_id)
		user_wall = user_wall_post.user_wall if user_wall_post
		if user_wall		
			user_wall.update_attribute(:updated_at, Time.now) 
			update_user_wall_follow(user_wall, current_user)
		end
	end

  private
  
  def authenticate
    if Rails.env == "staging"
		  authenticate_or_request_with_http_basic do |user_name, password| 
		    user_name == USER_NAME && password == PASSWORD   
		  end
		end
  end
  
  def set_user_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
end
