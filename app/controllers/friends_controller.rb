# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'contacts'
require 'email_veracity'

class FriendsController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user, :get_variables
  
  def index
    @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
    get_variables()
  end
  
  def search
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
      @friends = @user.user_friends.find(:all, :conditions => "name LIKE '%#{@search_name}%'").paginate :page => params[:page], :per_page => 10
    else
      @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
    end
  end
  
  def find
		type = "gmail"
		type = params[:mail_type] if params[:mail_type]
		login = params[:login] if params[:login]
    @mail_account = MailAccount.new(login, nil, type)
    user_id_suggestions = session[:user_id_suggestions]
    if user_id_suggestions.nil?
      user_id_suggestions = get_user_id_suggestions(@user)
      session[:user_id_suggestions] = user_id_suggestions
    end
    @user_suggestions = []
    @user_suggestions = User.find(:all, :conditions => "id IN(#{user_id_suggestions.join(", ")})") if user_id_suggestions.size > 0
  end
  
  def find_email
    login = params[:mail_account][:login]
    password = params[:mail_account][:password]
    mail_type = params[:mail_type]
    begin
      mail_account = MailAccount.new(login, password, mail_type)
      contacts = mail_account.contacts
      arr_mails = []
      contacts.collect {|m| arr_mails << m[1]}
      
      users = User.find(:all, :conditions => "email IN('#{arr_mails.join("', '")}')") if arr_mails.size > 0
      unless users.nil?
        user_id_friends = @user.user_friends.collect(&:id)
        user_id_by_mails = users.collect(&:id)
        user_id_suggestions = user_id_by_mails - user_id_friends
        session[:user_id_suggestions] = user_id_suggestions if user_id_suggestions.size > 0
        flash[:notice] = "Find successfuly."
      end
    rescue Contacts::AuthenticationError => oops
      flash[:error] = "Account email incorrect."
      error oops
    end
    redirect_to find_user_friends_path(@user, :mail_type => mail_type, :login => login)
  end

	def find_friend_by_email
		contacts = params[:email_list].split(",")
      contacts = contacts.collect {|c| c.strip}
      #begin
        flash[:notice] = "Find Friends Successfully."
        friends = @user.user_friends.find(:all, :conditions => ["email IN('#{contacts.join("', '")}')"])
				session[:user_id_suggestions] = friends.map(&:id)
      #rescue
        # Nothing
      #end
			redirect_to find_user_friends_path(@user)
	end
  
  def recently_added
    @invites = @user.user_invites_out.find(:all, :conditions => "is_accepted IS NULL")
  end
  
  def recently_updated
    @friends = @user.user_friends.find(:all, :order => "updated_at DESC").paginate :page => params[:page], :per_page => 10 
  end
  
  def friend_request
    @invites = @user.user_invites_in.find(:all, :conditions => "is_accepted IS NULL")
  end
  
  def list
    if params[:group]
      @group = FriendGroup.find_by_label(params[:group])
      @friend_in_groups = @user.friend_in_groups.find(:all, :conditions => ["friend_group_id = ?", @group]).paginate :page => params[:page], :per_page => 10
    else
      redirect_to :action => "index"
    end
  end
  
  def add_to_group
    if params[:check_status] == ""
      
      fig = FriendInGroup.new
      fig.user_id = current_user.id
      fig.friend_group_id = params[:group_id]
      fig.user_id_friend = params[:friend_id]
      user = User.find(params[:friend_id])
      if fig.save
        subject = "#{current_user.name} added you as a family member."
        content = "Hello #{user.name},<br/>"
        content << "#{current_user.name} just added you as a family member, click <a href='#{user_url(current_user)}' target='blank'>here</a> to see if you know #{current_user.name}."
        if params[:group_id] == "1"
          send_notification(user, subject, content, "confirms_a_friendship_request")
        end
        
        render :text => "Saved selected group successfully"
      else
        render :text => "Failed to save selected group"
      end
    else
      group = @user.friend_in_groups.find(:first, :conditions => ["friend_group_id = ? and user_id_friend = ?", params[:group_id], params[:friend_id]])
      if FriendInGroup.delete(group.id)
        render :text => "Removed group successfully"
      else
        render :text => "Failed to remove group"
      end
    end
  end
  
  def invite
    @mail_account = MailAccount.new(nil, nil, "gmail")
  end
  
  def unfriend
    friend_id = params[:friend_id]
    @user = User.find(friend_id)
    cond = Caboose::EZ::Condition.new :user_invites do
      any :user_invites do
        user_id == friend_id
        user_id_target == friend_id
      end
    end
    current_user.user_invites.find(:first, :conditions => cond.to_sql).destroy
  end
  
  def invite_by_list_email
    if params[:email_list]
      content = params[:content]
      content = "I found AfterClassroom as a great place for socialize and study after school, thus I would like to invite you to join" if content == ""
      contacts = params[:email_list].split(",")
      contacts = contacts.collect {|c| c.strip}
      mail_list = []
      begin
        flash[:notice] = "Invite Friends Successfully."
        contacts.collect {|c| mail_list << c if !c.nil? && c != "" && EmailVeracity::Address.new(c).valid? }
        for email in mail_list
          send_email(email, content)
        end
      rescue
        # Nothing
      end
    end
    redirect_to :action => "invite"
  end
  
  def invite_by_import_email
    content = params[:content]
    content = "I found After Classroom as a great place for socialize and study after school, thus I would like to invite you to join" if content == ""
    contacts = params[:contacts]
    for email in contacts
        send_email(email, content)
    end
    render :text => "Invite Friends Successfully."
  end
  
  def send_invite_by_import_email
    
  end

	def show_list_email_contacts
		content = params[:content]
    login = params[:mail_account][:login]
    password = params[:mail_account][:password]
    mail_type = params[:mail_type]
    begin
      mail_account = MailAccount.new(login, password, mail_type)
      contacts = mail_account.contacts
    rescue Contacts::AuthenticationError => oops
      error oops
    end
		render :json => contacts.to_json
	end
  
  def delete
    user_id_friend = params[:user_id_friend]
    cond = Caboose::EZ::Condition.new :user_invites do
      any :user_invites do
        user_id == user_id_friend
        user_id_target == user_id_friend
      end
    end
    @user.user_invites.find(:first, :conditions => cond.to_sql).destroy
    flash[:notice] = "Delete success."
    redirect_to :action => "index"
  end
  
  def display_email
    mail_box = params[:mailbox]
    @mail_account = MailAccount.new(nil, nil, mail_box)
    respond_to do |format|
      format.js do
        render :partial=>"mail_type", :layout => false
      end
    end
  end
  
  def accept
    @invite_id = params[:invite_id]
    @invite = @user.user_invites_in.find_by_id(@invite_id)
    @user_invite = @invite.user 
    @invite.is_accepted = true
    @invite.save
    subject = "#{current_user.name} has accepted you as a friend."
    content = "Hello #{@user_invite.name}, <br/>"
    content << "<p>#{current_user.name} has accepted you as a friend, click <a href='#{user_url(current_user)}' target='blank'>here</a> to check out #{current_user.name}'s  photo.</p>"
    send_notification(@user_invite, subject, content, "confirms_a_friendship_request")
  end
  
  def de_accept
    @invite_id = params[:invite_id]
    @invite = @user.user_invites_in.find_by_id(@invite_id)
    @user_invite = @invite.user
    @invite.destroy
  end
  
  def show_invite
    @user_invite = params[:user_invite]
    user = User.find_by_id(@user_invite)
    @full_name = user.full_name
    render :layout => false
  end
  
  def respond_to_friend_request
    friend_id = params[:friend_id]
    @user = User.find_by_id(friend_id)
    @invite = current_user.user_invites_in.find_by_user_id(@user.id)
    render :layout => false
  end
  
  def send_invite_message
    user_id_friend = params[:user_invite]
    invite_message = params[:invite_message] || "let's be friends!"
    user = User.find(user_id_friend)
    if (user && invite_message)
        UserInvite.create(:user_id => current_user.id, :user_id_target => user_id_friend, :message => invite_message)
        subject = "#{current_user.name} want to be friend with you."
        content = "Hello #{user.name},<br/>"
        content << "<p>#{current_user.name} want to be friend with you, click <a href='#{user_url(current_user)}' target='blank'>here</a> to see  if you know #{current_user.name} OR click <a href='#{friend_request_user_friends_url(user)}' target='blank'>here</a> to confirm #{current_user.name} is your friend.</p>"
        send_notification(user, subject, content, "adds_me_as_a_friend")
    end
    render :text => '<div class="txtsignup1">Still waiting</div>'
  end
  
  def become_a_fan
    user_follow = User.find(params[:fan_id])
    
    fan = Fan.new
    fan.user_id = current_user.id
    user_follow.fans << fan
    subject = "One more person added as your fan."
    content = "Dear #{user.name},<br/>"
    content << "<p>#{current_user.name} just became your fan. Your total fan now is #{user.fans.size}, click <a href='#{fan_user_profiles_url(user)}'>here</a> to review all of your fans.</p>"
    send_notification(user, subject, content, "adds_me_as_a_friend")
    render :text => "You are a fan"
  end
  
  def find_people
    @query = params[:search][:query]
    @users = User.search do
      if params[:search][:query].present?
        keywords(params[:search][:query]) do
          highlight :name
        end
      end
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 10
    end
  end
  
  protected
  
  def get_variables
    @count_recentadded = @user.user_invites_out.count(:all, :conditions => "is_accepted IS NULL")
    @count_recentupdate = @user.user_friends.count(:all)
    @count_request = @user.user_invites_in.count(:all, :conditions => "is_accepted IS NULL")
    
    
    fam_group = FriendGroup.find_by_label("family_members")
    @count_faminly = @user.friend_in_groups.count(:all, :conditions => ["friend_group_id = ?", fam_group])
    
    school_group = FriendGroup.find_by_label("friends_from_school")
    @count_sch = @user.friend_in_groups.count(:all, :conditions => ["friend_group_id = ?", school_group])
    
    
    work_group = FriendGroup.find_by_label("friends_from_work")
    @count_work = @user.friend_in_groups.count(:all, :conditions => ["friend_group_id = ?", work_group])
    
  end
  
  def require_current_user
    @user ||= User.find(params[:user_id] || params[:id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
  
  def get_user_id_suggestions(user)
    user_id_friends = user.user_friends.collect(&:id)
    friend_of_friend = []
    user.user_friends.each do |f|
      f.user_friends.each do |ff|
        friend_of_friend << ff.id unless user == ff
      end
    end
    friend_of_friend = friend_of_friend.uniq
    user_id_suggestions = friend_of_friend - user_id_friends
  end
  
  def send_email(email, content)
    friend_invitation = FriendInvitation.new
    friend_invitation.user = current_user
    friend_invitation.email = email
    friend_invitation.save
    friend_invitation.reload
    UserMailer.deliver_invitation(current_user, email, request.host_with_port, friend_invitation.invitation_code, content)
  end
  
end
