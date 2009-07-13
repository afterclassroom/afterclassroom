# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class StudentLougeController < ApplicationController
  before_filter :login_required

  def index
		user_login = params[:user]
    @user_invite_chat = User.find_by_login(user_login) if user_login != current_user.login
		@friends_change = current_user.friends_change_message
		@friends_want = current_user.friends_want_chat
		@friends_invite = current_user.friends_invite_chat
		@friends_in_chat = current_user.friends_in_chat

  end
	
	def invite_chat
		user_login = params[:user]
		user_invite_chat = User.find_by_login(user_login)

		#Check and create chanel
		if user_invite_chat
      chanel_name = "chanel_" + current_user.login + "_" + user_invite_chat.login
			flirting_chanel = FlirtingChanel.create({:chanel_name => chanel_name})
      flirting_massage = FlirtingMessage.new({:user_id => current_user.id, :message => "#{current_user.full_name} invite #{user_invite_chat.full_name} to chat.", :notify_msg => true})
      flirting_chanel.flirting_messages << flirting_massage
      flirting_chanel.flirting_user_inchats << FlirtingUserInchat.new({:user_id => current_user.id, :status => "Create"})
      flirting_chanel.flirting_user_inchats << FlirtingUserInchat.new({:user_id => user_invite_chat.id, :user_id_invite => current_user.id})
      flirting_chanel.save
      render :juggernaut => {:type => :send_to_client, :client_id => user_invite_chat.login} do |page|
        page.insert_html :top, "friends_want_chat", "<li>" + image_tag(flirting_chanel.user.avatar.url(:thumb), :onclick => "mydow_open('#{flirting_chanel.user.id}', '#{flirting_chanel.user.full_name}')") + "</li>"
      end
		end
		
		render :nothing => true
	end
	
  def add_user_to_chat
    user_id = params[:user_id]
    chanel_name = params[:chanel_name]
		user_chat = User.find(user_id)
		chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    user_in_chat = FlirtingUserInchat.find_by_user_id(user_id)
		if user_in_chat == nil
      user_in_chat = FlirtingUserInchat.new({:user_id => user_chat.id, :user_id_invite => current_user.id})
			chanel.flirting_user_inchats << user_in_chat
      chanel.save
      client_ids = []
      for user_inchat in chanel.flirting_user_inchats
        client_ids << user_inchat.user.login
      end
      message = "#{current_user.full_name} add #{user_chat.full_name} to chat"
			msg = FlirtingMessage.new({:user_id => current_user.id, :message => message})
			chanel.flirting_messages << msg
			chanel.save
			render :juggernaut => {:type => :send_to_clients, :client_ids => client_ids} do |page|
				page.insert_html :bottom, chanel.chanel_name, "<li>#{h current_user.full_name}: #{h message}</li>"
				page.call 'scroll_div', 'chat_content_' + chanel.chanel_name
			end
		end
		
    render :nothing => true
  end
  
	def send_data
		message = params[:chat_input]
    chanel_name = params[:chanel_name]
		chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
		if chanel
			user_in_chat = chanel.flirting_user_inchats.find_by_user_id(current_user.id)
      user_in_chat.status = "Chat" if user_in_chat.status == "Invite"
      user_in_chat.save
      client_ids = []
      for user_inchat in chanel.flirting_user_inchats
        client_ids << user_inchat.user.login
      end
			msg = FlirtingMessage.new({:user_id => current_user.id, :message => message})
			chanel.flirting_messages << msg
			chanel.save
			render :juggernaut => {:type => :send_to_clients, :client_ids => client_ids} do |page|
				page.insert_html :bottom, chanel.chanel_name, "<li>#{h current_user.full_name}: #{h message}</li>"
				page.call 'scroll_div', 'chat_content_' + chanel.chanel_name
			end
		end
		
    render :nothing => true
	end
	
	def stop_chat
		user_id = params[:user_id]
    chanel_name = params[:chanel_name]
    
		user_chat = User.find(user_id)
		chanel = FlirtingChanel.find_by_chanel_name(chanel_name)
    
		if chanel
      user_in_chat = FlirtingUserInchat.find_by_user_id(user_id)
      user_in_chat.destroy if user_in_chat
      
			if chanel.flirting_user_inchats.size == 0
				chanel.destroy
      else
        client_ids = []
        for user_inchat in chanel.flirting_user_inchats
          client_ids << user_inchat.user.login
        end
        message = "#{current_user.full_name} stoped chatting."
        msg = FlirtingMessage.new({:user_id => current_user.id, :message => message})
        chanel.flirting_messages << msg
        render :juggernaut => {:type => :send_to_clients, :client_ids => client_ids} do |page|
          page.insert_html :bottom, chanel.chanel_name, "<li>#{h message}</li>"
        end
			end
			chanel.save
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
	end

end
