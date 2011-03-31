# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  include Viewable
  include Postwall
  include SimpleCaptcha::ControllerHelpers
  
  helper :all # include all helpers, all the time
  #config.filter_parameters :password, :password_confirmation
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '9fe6825f97cc334d88925fde5c4808a8'
  
  # Temp
  USER_NAME, PASSWORD = "afterclassroom", "teamwork"
  
  before_filter :authenticate
  
  def help
    Helper.instance
  end
  
  class Helper
    include Singleton
    include ActionView::Helpers::UrlHelper
  end
  
  def object_with_type(type, id)
    item = nil
    case type
      when "Post"
      item = Post.find(id)
      when "Story"
      item = Story.find(id)
      when "Photo"
      item = Photo.find(id)
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
    end
     
    # Set session your school
    session[:your_school] = self.current_user.school.id if self.current_user
  end
  
  private
  
  def authenticate
    
    authenticate_or_request_with_http_basic do |user_name, password|
      
      user_name == USER_NAME && password == PASSWORD
      
    end
    
  end
  
end
