# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SettingsController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user
	after_filter :store_location, :only => [:setting]
  
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
          @nfst.save!
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
          @nfse.save!
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
    render :text => hash.index(val.to_i)
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
    if current_user == @user and @user.email != "demotoyou@gmail.com"
      current_password, new_password, new_password_confirmation = params[:current_password], params[:new_password], params[:new_password_confirmation]
      if User.password_digest(current_password, @user.salt) == @user.crypted_password
        if new_password == new_password_confirmation
          if new_password.blank? || new_password_confirmation.blank?
            flash[:error] = "You cannot set a blank password."
          else
            @user.password = new_password
            @user.password_confirmation = new_password_confirmation
            @user.save
            flash[:notice] = "Your password has been updated."
          end
        else
          flash[:error] = "Your new password and it's confirmation don't match."
        end
      else
        flash[:error] = "Your current password is not correct.<br/>Your password has not been updated."
      end
    else
      flash[:error] = "You cannot update another user's password!"
    end
    redirect_to :action => "setting"
  end
  
  def change_name
    render :layout => false
  end
  
  def save_name
    if current_user == @user and @user.email != "demotoyou@gmail.com"
      @user = current_user
      @user.name = params[:changed_value]
      if @user.save
        flash[:notice] = "Updated your name successfully"
      else
        flash[:error] = "Updated your name failed"
      end
    else
      flash[:error] = "You cannot update another user's name!"
    end
    redirect_to :action => "setting"
  end

	def change_user_name
    render :layout => false
  end
  
  def save_user_name
    if current_user == @user and @user.email != "demotoyou@gmail.com"
      @user = current_user
			login = params[:username]
			logins = User.where(:login => login.downcase)
			if logins.size > 0
				flash[:error] = "Username '#{login}' already exists"
			else
				@user.login = login
		    if @user.save!
		      flash[:notice] = "Updated your username successfully"
		    else
		      flash[:error] = "Updated your username failed"
		    end
			end
    else
      flash[:error] = "You cannot update another username!"
    end
    redirect_to setting_user_settings_url(@user)
  end
  
  def change_email
    render :layout => false
  end
  
  def save_email
    if current_user == @user and @user.email != "demotoyou@gmail.com"
      if @user.update_attributes(:email => params[:email])
        flash[:notice] = "Your email address has been updated."
      else
        flash[:error] = "Your email address could not be updated."
      end
    else
      flash[:error] = "You cannot update another user's email address!"
    end
    redirect_to :action => "setting"
  end
  
  def change_time_zone
    render :layout => false
  end

	def change_chat_id
		@type = params[:type]
		render :layout => false
	end

	def save_chat_id
		chat_id = params[:chat_id]
		type = params[:type]
		chat = UserIdChat.find_or_create_by_user_id_and_type_chat(@user.id, type)
		chat.chat_id = chat_id
		chat.type_chat = type
		if chat.save
			flash[:notice] = "Your chat id has been updated."
		else
			flash[:error] = "Your chat id could not be updated."
		end
		redirect_to :action => "setting"
	end
  
  
  def save_time_zone
    if current_user == @user
      if @user.update_attributes(:time_zone => params[:time_zone][0])
        flash[:notice] = "Time zone has been updated."
      else
        flash[:error] = "Time zone could not be updated."
      end
    else
      flash[:error] = "You cannot update another user's Time zone!"
    end
    redirect_to :action => "setting"
  end

	def check_login
		username = params[:username]
		logins = User.where(:login => username.downcase)
		render :text => (logins.size > 0) ? "invalid" : "valid"
	end

	def change_school
		render :layout => false
	end

	def save_school

	end

	def blocks
		@user_blocks = @user.user_blocks.order("created_at DESC")
	end

	def unblock
		@user_id_block = params[:user_id_block]
		user_block = UserBlock.find(@user_id_block)
		if @user.user_blocks.include?(user_block)
			user_block.destroy
		end
		render :layout => false
	end

  private
  def require_current_user
    @user ||= User.find(params[:user_id] || params[:id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
