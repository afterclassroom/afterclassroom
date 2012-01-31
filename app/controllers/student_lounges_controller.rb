# � Copyright 2009 AfterClassroom.com � All Rights Reserved
class StudentLoungesController < ApplicationController
  layout 'student_lounge'
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter
  #before_filter :cas_user
  before_filter :login_required
  
  def index
    @type = "student_lounge"
    @user = current_user
    user_login = params[:user]
    @walls = []
    @walls = @user.walls_with_setting.paginate :page => params[:page], :per_page => 10
  end
  
end
