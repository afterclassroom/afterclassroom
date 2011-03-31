# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::SetnotifiesController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
    @notifications = Notification.find(:all, :order => "notify_type")
  end

  def addnew
    @notification = Notification.new
  end

  def save

    sms_box = params[:sms]
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "VALUE SMS== "+params[:sms].to_s
    puts "VALUE MOBILE ==  "+params[:email].to_s
    puts "VALUE combobox ==  "+params[:list_cate].to_s
    puts "VALUE name ==  "+params[:name].to_s

    redirect_to :action => "index"
  end
  
end
