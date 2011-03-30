# � Copyright 2009 AfterClassroom.com � All Rights Reserved
class StudentLoungesController < ApplicationController
  layout 'student_lounge'
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  
  def index
    @user = current_user
    user_login = params[:user]
    @walls = []
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    @user_invite_chat = User.find_by_login(user_login) if user_login != current_user.login
    @friends_in_chat = current_user.friends_in_chat
    @friends_want = current_user.friends_want_chat
  end
  
  def chat
    @user = current_user
    user_login = params[:user]
    @walls = []
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    @user_invite_chat = User.find_by_login(user_login) if user_login != current_user.login
    @friends_in_chat = current_user.friends_in_chat
    @friends_want = current_user.friends_want_chat
  end
  
  def invite_chat
    
    user_id = params[:user_id]
    user_invite_chat = User.find(user_id)
    
    #Check and create chanel
    if user_invite_chat
      chanel_name = "chanel_#{current_user.id}_#{user_invite_chat.id}"
      message = "#{current_user.full_name} invite #{user_invite_chat.full_name} to chat."
      flirting_chanel = FlirtingChanel.create({:chanel_name => chanel_name})
      flirting_massage = FlirtingMessage.new({:user_id => current_user.id, :message => message, :notify_msg => true})
      flirting_chanel.flirting_messages << flirting_massage
      flirting_chanel.flirting_user_inchats << FlirtingUserInchat.new({:user_id => current_user.id, :user_id_invite => user_invite_chat.id, :status => "Create"})
      flirting_chanel.flirting_user_inchats << FlirtingUserInchat.new({:user_id => user_invite_chat.id, :user_id_invite => current_user.id})
      flirting_chanel.save
      client_ids = []
      for user_inchat in flirting_chanel.flirting_user_inchats
        client_ids << "chat_" + user_inchat.user.id.to_s if user_inchat.user.login != current_user.login
      end
      Juggernaut.publish(client_ids, {:chanel_name => flirting_chanel.chanel_name, :message => "<li>" + message + "</li>", :event => "invite_chat"})
    end
    render :nothing => true
  end
  
  def add_users_to_chat
    users_id = params[:users_id]
    arr_id = users_id.split(";")
    chanel_name = params[:chanel_name]
    chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    arr_msg = ""
    for id in arr_id
      user_chat = User.find(id)
      user_in_chat = chanel.flirting_user_inchats.find_by_user_id(id)
      if user_in_chat == nil
        user_in_chat = FlirtingUserInchat.new({:user_id => user_chat.id, :user_id_invite => current_user.id})
        chanel.flirting_user_inchats << user_in_chat
        chanel.save
        message = "#{current_user.full_name} add #{user_chat.full_name} to chat"
        arr_msg = "<li>" + message + "</li>"
        msg = FlirtingMessage.new({:user_id => current_user.id, :message => message, :notify_msg => true})
        chanel.flirting_messages << msg
        chanel.save
      end
    end
    client_ids = []
    for user_inchat in chanel.flirting_user_inchats
      client_ids << "chat_" + user_inchat.user.id.to_s 
    end
    Juggernaut.publish(client_ids, {:chanel_name => chanel.chanel_name, :message => arr_msg, :event => "add_users_to_chat"})
    render :nothing => true
  end
  
  def send_data
    message = params[:chat_input]
    chanel_name = params[:chanel_name]
    chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    accept_invite = false
    if chanel
      user_in_chat = chanel.flirting_user_inchats.find_by_user_id(current_user.id)
      if user_in_chat.status == "Invite"
        user_in_chat.status = "Chat" 
        accept_invite = true
      end
      user_in_chat.save
      client_ids = []
      for user_inchat in chanel.flirting_user_inchats
        client_ids << "chat_" + user_inchat.user.id.to_s
      end
      msg = FlirtingMessage.new({:user_id => current_user.id, :message => message})
      chanel.flirting_messages << msg
      chanel.save
      Juggernaut.publish(client_ids, {:chanel_name => chanel.chanel_name, :message => "<li>#{h current_user.full_name}: #{h message}</li>", :event => "send_data"})
    end
    
    render :nothing => true
  end
  
  def stop_chat
    chanel_name = params[:chanel_name]
    
    chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    
    if chanel  
      client_ids = []
      for user_inchat in chanel.flirting_user_inchats
        client_ids << "chat_" + user_inchat.user.id.to_s
      end
      
      if chanel.flirting_user_inchats.size == 2
        chanel.destroy
      else
        user_in_chat = FlirtingUserInchat.find_by_user_id(current_user.id)
        user_in_chat.destroy if user_in_chat
        chanel.save
      end
      message = "#{current_user.full_name} stoped chatting."
      msg = FlirtingMessage.new({:user_id => current_user.id, :message => message, :notify_msg => true})
      chanel.flirting_messages << msg
      Juggernaut.publish(client_ids, {:chanel_name => chanel.chanel_name, :message => "<li>#{h message}</li>", :event => "stop_chat"})
    end
    
    render :nothing => true
  end
  
  def chanel_chat_content
    chanel_name = params[:chanel_name]
    @chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    user_in_chat = FlirtingUserInchat.find_by_flirting_chanel_id_and_user_id(@chanel.id, current_user.id)
    @user_with_chat = User.find(user_in_chat.user_id_invite)
    if @chanel
      @messages = @chanel.flirting_messages
    end
    render :layout => false
  end
  
  def friends_changed_message
    @friends_change = current_user.friends_change_message
    render :layout => false
  end
  
  def friends_you_invited_chat
    @friends_invite = current_user.friends_invite_chat
    render :layout => false
  end
  
  def friends_want_you_chat
    @friends_want = current_user.friends_want_chat
    render :layout => false
  end

  def friends_online
    @friends_online = current_user.friends_online
    render :layout => false
  end
end
