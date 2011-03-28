# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::SetnotifiesController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
    @notifications = Notification.find(:all, :order => "notify_type")
  end

  def addnew
    render :layout => false
  end
end
