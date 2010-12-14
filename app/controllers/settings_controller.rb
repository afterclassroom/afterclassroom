# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SettingsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required
  
  def index
    redirect_to :action => "setting"
  end

  def save_setting

    #UPDATE SMS SETTING
    smsarrs = params[:smsarr]
    if smsarrs != nil
      if smsarrs != nil
      
        current_user.notify_sms_settings.destroy_all

        smsarrs.each do |eachsms|
          @nfst = NotifySmsSetting.new
          @nfst.notification = Notification.find(eachsms)
          @nfst.user = current_user
        end
      end
    end

    #UPDATE EMAIL SETTING
    emailarrs = params[:emailarr]
    if emailarrs != nil
      puts "mysmsarr == "+emailarrs.length.to_s
      if emailarrs != nil

        current_user.notify_email_settings.destroy_all

        emailarrs.each do |eachemail|
          puts "each == " + eachemail.to_s
          @nfse = NotifyEmailSetting.new
          @nfse.notification = Notification.find(eachemail)
          @nfse.user = current_user
        end
      end
    end

    redirect_to :action => "notifications"
  end

  def setting
    if @inf_msg != nil
      notice @inf_msg
    end
  end
  
  def private
  end

  def networks
  end

  def notifications
    @types = [["afterclassroomtab", "AfterClassroom"],
      ["photostab", "Photos"],
      ["groupstab", "Groups"],
      ["pagestab", "Pages"],
      ["eventstab", "Events"],
      ["storytab", "Story"],
      ["linkstab", "Links"],
      ["musictab", "Music"],
      ["videotab", "Video"],
      ["giftstab", "Gifts"],
      ["helptab", "Help"],
      ["loungetab", "Lounge"],
      ["othertab", "Others"]]
  end

  def language
  end

  def payments
  end
  
  def ads
  end

  def change_psw
    render :layout => false
  end

  def save_psw
    @user = current_user
    @user.password = params[:password]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def change_name
    render :layout => false
  end

  def save_name
    @user = current_user
    @user.name = params[:changed_value]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def change_email
    render :layout => false
  end

  def save_email
    @user = current_user
    @user.email = params[:changed_value]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end



end
