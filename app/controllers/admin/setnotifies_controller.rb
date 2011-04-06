# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::SetnotifiesController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
    if (@notify_message == nil)
      @notify_message = ""
    end
    @notifications = Notification.find(:all, :order => "notify_type")
    
  end

  def addnew
    @notification = Notification.new
  end

  def edit
    @notification = Notification.find(params[:selectedID])
  end

  def save_edit


    sms_box = params[:sms]

    @notification = Notification.find(params[:editing_id])
    @notification.name = params[:name].to_s

    if params[:email].to_s != ""
      @notification.email_allow = true
    else
      @notification.email_allow = false
    end
    if params[:sms].to_s != ""
      @notification.sms_allow = true
    else
      @notification.sms_allow = false
    end

    @notification.notify_type = params[:list_cate].to_s
    @notification.label = @notification.name.downcase
    @notification.label.gsub!(" ", "_")


    if @notification.save
      @notify_message = "Success edit Notification"
    else
      @notify_message = "Failed to edit Notification"
    end
    
    redirect_to :action => "index"
  end

  def delete
    @notification = Notification.find(params[:selectedID])
    @notification.destroy
    @notify_message = "Success delete Notification"
    redirect_to :action => "index"
  end

  def save
    sms_box = params[:sms]

    @notification = Notification.new
    @notification.name = params[:name].to_s

    if params[:email].to_s == "on"
      @notification.email_allow = true
    else
      @notification.email_allow = false
    end
    if params[:sms].to_s == "on"
      @notification.sms_allow = true
    else
      @notification.sms_allow = false
    end
     
    @notification.notify_type = params[:list_cate].to_s
    @notification.label = @notification.name.downcase
    @notification.label.gsub!(" ", "_")
    

    if @notification.save
      @notify_message = "Success create new Notification"
    else
      @notify_message = "Failed to create new Notification"
    end

    redirect_to :action => "index"
  end
  
end
