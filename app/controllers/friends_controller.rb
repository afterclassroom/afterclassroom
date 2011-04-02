# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'contacts'
require 'email_veracity'

class FriendsController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user
  
  def index
    @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
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
    @mail_account = MailAccount.new(nil, nil, "gmail")
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
    mail_account = MailAccount.new(login, password, mail_type)
    begin
      contacts = mail_account.contacts
      arr_mails = []
      contacts.collect {|m| arr_mails << m[1]}
      
      users = User.find(:all, :conditions => "email IN('#{arr_mails.join("', '")}')") if arr_mails.size > 0
      unless users.nil?
        user_id_friends = @user.user_friends.collect(&:id)
        user_id_by_mails = users.collect(&:id)
        user_id_suggestions = user_id_by_mails - user_id_friends
        session[:user_id_suggestions] = user_id_suggestions if user_id_suggestions.size > 0
        flash.now[:notice] = "Find successfuly."
      end
    rescue Contacts::AuthenticationError => oops
      flash.now[:error] = "Account email incorrect."
      error oops
    end
    redirect_to find_user_friends_path(@user)
  end

  def recently_added
    @invites = @user.user_invites_out.find(:all, :conditions => "is_accepted IS NULL")
  end

  def recently_updated

  end

  def friend_request
    @invites = @user.user_invites_in.find(:all, :conditions => "is_accepted IS NULL")
  end
  
  def list
    if params[:check_status] == ""

      fig = FriendInGroup.new
      fig.user_id = current_user.id
      fig.friend_group_id = params[:group_id]
      fig.user_id_friend = params[:friend_id]
      if fig.save
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

  def invite_by_list_email
    if params[:email_list]
      content = params[:content]
      content = "I found After Classroom as a great place for socialize and study after school, thus I would like to invite you to join" if content == ""
      contacts = params[:email_list].split(",")
      contacts = contacts.collect {|c| c.strip}
      mail_list = []
      contacts.collect {|c| mail_list << c if !c.nil? && c != "" && EmailVeracity::Address.new(c).valid? }
      for email in mail_list
        send_email(email, content)
      end
    end
    flash.now[:notice] = "Invite Friends Successfully."
    redirect_to :action => "invite"
  end

  def invite_by_import_email
    content = params[:content]
    content = "I found After Classroom as a great place for socialize and study after school, thus I would like to invite you to join" if content == ""
    login = params[:mail_account][:login]
    password = params[:mail_account][:password]
    mail_type = params[:mail_type]
    mail_account = MailAccount.new(login, password, mail_type)
    begin
      contacts = mail_account.contacts
      arr_mails = []
      contacts.collect {|m| arr_mails << m[1]}
      for email in arr_mails
        send_email(email, content)
      end
    rescue Contacts::AuthenticationError => oops
      error oops
    end
    flash.now[:notice] = "Invite Friends Successfully."
    redirect_to :action => "invite"
  end
  
  def send_invite_by_import_email
    
  end

  def delete
    user_id_friend = params[:user_id_friend]
    @user.user_invites.find_by_user_id_target(user_id_friend).destroy
    @user.reload
    flash[:notice] = "Delete success."
    redirect_to :action => "index"
  end

  def display_email
    mail_box = params[:mailbox]
    @mail_account = MailAccount.new(nil, nil, mail_box)
    respond_to do |format|
      format.js do
        render :partial=>"mail_type",:layout=>false
      end
    end
  end

  def accept
    invite_id = params[:invite_id]
    invite = @user.user_invites_in.find_by_id(invite_id)
    invite.is_accepted = true
    invite.save
    render :text => "Successful."
  end

  def de_accept
    invite_id = params[:invite_id]
    invite = @user.user_invites_in.find_by_id(invite_id)
    invite.destroy
    render :text => "Successful."
  end

  def show_invite
    @user_invite = params[:user_invite]
    user = User.find_by_id(@user_invite)
    @full_name = user.full_name
    render :layout => false
  end

  def send_invite_message

    user_id_friend = params[:user_invite]
    invite_message = params[:invite_message] || "let's be friends!"
    
    if (user_id_friend && invite_message)
      UserInvite.create(:user_id => current_user.id, :user_id_target => user_id_friend, :message => invite_message)
      render :text => "Waiting accept"
    end
  end

  def become_a_fan
    @user_id = params[:user_id]
    user_follow = User.find(params[:user_id])

    fan = Fan.new
    fan.user_id = current_user.id 
    user_follow.fans << fan

    render :text => "You are a fan"
  end
  
  def find_people
    @query = params[:search][:query]
    @users = User.search(@query, :match_mode => :any, :order => "created_at DESC", :page => params[:page], :per_page => 10)
  end
  
  protected

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