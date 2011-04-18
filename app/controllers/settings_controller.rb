# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SettingsController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  
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
    else
      current_user.notify_sms_settings.destroy_all
    end
    
    #UPDATE EMAIL SETTING
    emailarrs = params[:emailarr]
    if emailarrs != nil
      if emailarrs != nil
        
        current_user.notify_email_settings.destroy_all
        
        emailarrs.each do |eachemail|
          @nfse = NotifyEmailSetting.new
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
    else
      current_user.notify_email_settings.destroy_all
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
  
  def save_private_setting
    type = params[:type]
    val = params[:value]
    
    pr = PrivateSetting.find_or_create_by_user_id_and_type_setting(current_user.id, type)
    pr.share_to = val.to_i
    pr.save
    hash = Hash[OPTIONS_SETTING.map {|x| [x[0], x[1]]}]
    render :text => "Share to: " + hash.index(val.to_i)
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
  
  def change_psw
    render :layout => false
  end
  
  def save_psw
    @user = current_user
    @user.password = params[:password]
    if @user.save
      flash[:notice] = "Updated Successfully"
      redirect_to :action => "setting"
    else
      flash[:error] = "Updated Failed"
      redirect_to :action => "setting"
    end
  end
  
  def change_name
    render :layout => false
  end
  
  def save_name
    @user = current_user
    @user.name = params[:changed_value]
    if @user.save
      flash[:notice] = "Updated Successfully"
      redirect_to :action => "setting"
    else
      flash[:error] = "Updated Failed"
      redirect_to :action => "setting"
    end
  end
  
  def change_email
    render :layout => false
  end
  
  def save_email
    @user = current_user
    @user.email = params[:changed_value]
    if @user.save
      flash[:notice] = "Updated Successfully"
      redirect_to :action => "setting"
    else
      flash[:error] = "Updated Failed"
      redirect_to :action => "setting"
    end
  end
end
