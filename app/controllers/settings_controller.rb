# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SettingsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required
  
  def index
    redirect_to :action => "setting"
  end

  def savesetting
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"
    puts "============================"

    #UPDATE SMS SETTING
    smsarrs = params[:smsarr]
    if smsarrs != nil
      puts "mysmsarr == "+smsarrs.length.to_s
      if smsarrs != nil
      
        current_user.notify_sms_settings.destroy_all

        smsarrs.each do |eachsms|
          puts "each == " + eachsms.to_s
          @nfst = NotifySmsSetting.new
          @nfst.notification = Notification.find(eachsms)
          @nfst.user = current_user

          if @nfst.save
            puts "save setting successfully"
          else
            puts "failed to save setting"
          end

          puts "selected notification == "+@nfst.notification.name
        end
      end
    end

    #UPDATE EMAIL SETTING
    emailarrs = params[:emailarr]
    if emailarrs != nil
      puts "mysmsarr == "+emailarrs.length.to_s
      if emailarrs != nil

        current_user.notify_emails.destroy_all

        emailarrs.each do |eachemail|
          puts "each == " + eachemail.to_s
          @nfse = NotifyEmail.new
          @nfse.notification = Notification.find(eachemail)
          @nfse.user = current_user

          if @nfse.save
            puts "save setting successfully"
          else
            puts "failed to save setting"
          end

          puts "selected notification == "+@nfse.notification.name
        end
      end
    end

    puts "============================"
    puts "============================"
    puts "============================"
    redirect_to :action => "networks"
  end

  def setting
    notice @inf_msg
  end

  def networks
  end

  def notifications
    @notifications = Notification.find(:all)
    @types = Notification.find( :all, :select => 'DISTINCT notify_type' )
  end

  def language
  end

  def payments
  end
  
  def ads
  end

  def changepsw
    render :layout => false
  end

  def savepsw
    @user = current_user
    @user.password = params[:password]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def changename
    render :layout => false
  end

  def savename
    @user = current_user
    @user.name = params[:changedValue]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def changeEmail
    render :layout => false
  end

  def saveEmail
    @user = current_user
    @user.email = params[:changedValue]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end



end