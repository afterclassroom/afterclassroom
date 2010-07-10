# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class LearningtoolsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def recommendtool
    
  end
  def tooltab
    render :layout => false
  end
  def populartab
    render :layout => false
  end
  def verifiedtab
    render :layout => false
  end
  def recentlyaddedtab
    render :layout => false
  end
  def seealltab
    render :layout => false
  end


end