# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'contacts'

class FriendsController < ApplicationController
  layout 'student_lounge'
  
  before_filter :login_required
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
    @user_suggestions = User.find(:all, :conditions => "id IN(#{user_id_suggestions.join(", ")})", :limit => 6) if user_id_suggestions.size > 0
  end

  def find_email
    login = params[:mail_account][:login]
    password = params[:mail_account][:password]
    mail_type = params[:mail_account][:mail_type]
    mail_account = MailAccount.new(login, password, mail_type)
    begin
      contacts = mail_account.contacts
      arr_mails = []
      contacts.collect {|m| arr_mails << m[1]}
      users = User.find(:all, :conditions => "email IN('#{arr_mails.split("', '")}')") if arr_mails.size > 0
      unless users.nil?
        user_id_friends = @user.user_friends.collect(&:id)
        user_id_by_mails = users.collect(&:id)
        user_id_suggestions = user_id_by_mails - user_id_friends
        session[:user_id_suggestions] = user_id_suggestions if user_id_suggestion.size > 0
        notice "Find successfuly."
      end
    rescue Contacts::AuthenticationError => oops
      error oops
    end
    redirect_to find_user_friends_path(@user)
  end

  def recently_added

  end

  def recently_updated
    
  end
  
  def list
    if params[:group]
      @group = FriendGroup.find_by_label(params[:group])
      @friend_in_groups = @user.friend_in_groups.find(:all, :conditions => ["friend_group_id = ?", @group]).paginate :page => params[:page], :per_page => 10
    else
      redirect_to :action => "index"
    end
  end

  def invite
    
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
        render :partial=>"mail_form",:layout=>false
      end
    end
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
end
