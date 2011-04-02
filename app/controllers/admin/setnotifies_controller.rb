# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::SetnotifiesController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
    @notifications = Notification.find(:all, :order => "notify_type")
    @notify_message = ""
  end

  def addnew
    @notification = Notification.new
  end

  def delete
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "HELLO WORLD"
    puts "selectedID == " +params[:selectedID].to_s

    # find all setting notification related and destroy them 

    @notification = Notification.find(params[:selectedID])

    @notification.destroy



#    @notification.destroy

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
