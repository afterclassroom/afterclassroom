# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '9fe6825f97cc334d88925fde5c4808a8'

  # Pick a unique cookie name to distinguish our session data from others
  session :session_key => '_geokit_session_id'

  # Auto-geocode the user's ip address and store it in the session
  geocode_ip_address

  # Temp
  USER_NAME, PASSWORD = "afterclassroom", "teamwork"

  #before_filter :authenticate
  before_filter :session_update

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
  
  private

  def authenticate

    authenticate_or_request_with_http_basic do |user_name, password|

      user_name == USER_NAME && password == PASSWORD

    end

  end
  
  def session_update
    session.model.update_attribute(:user_id, session[:user_id])
    session.model.update_attribute(:last_url_visited, request.url)
  end

  def save_url
    session.model.update_attribute(:go_back_url, request.url)
  end

  # Temp
end
