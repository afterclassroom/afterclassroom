# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class StudentLougeController < ApplicationController
  before_filter :login_required

  def index
		user_login = params[:user]
		user_invite_chat = User.find_by_login(user_login)

		#Check and create chanel
		if user_invite_chat
			flirting_chanel_invited = FlirtingChanel.find_by_user_id_and_user_id_target(user_invite_chat.id, current_user.id)#Use check current user invited
			if flirting_chanel_invited == nil
				@flirting_chanel = FlirtingChanel.find_or_create_by_user_id_and_user_id_target(current_user.id, user_invite_chat.id)
				@flirting_chanel.chanel_name = "chanel_" + current_user.login + "_" + user_invite_chat.login if !@flirting_chanel.chanel_name
				@flirting_chanel.status = "Invite" if @flirting_chanel.status == "End" 
				@flirting_chanel.save
			else
				if flirting_chanel_invited.status == "End"
					flirting_chanel_invited.status = "Invite"
				else
					flirting_chanel_invited.status = "Chat" if @flirting_chanel.status = "Invite"
				end
				flirting_chanel_invited.save
				@flirting_chanel = flirting_chanel_invited
			end
			if @flirting_chanel.status == "Invite" and @flirting_chanel.flirting_messages.size == 0
				flirting_massage = FlirtingMessage.new({:user_id => current_user.id, :message => "#{current_user.full_name} invite #{user_invite_chat.full_name} to chat."})
				@flirting_chanel.flirting_messages << flirting_massage
				@flirting_chanel.save
			end
		end
		@chanels_name = current_user.get_all_chanels_name
		@friends_change = current_user.friends_change_message
		@friends_want = current_user.friends_want_chat
		@friends_invite = current_user.friends_invite_chat
		@friends_in_chat = current_user.friends_in_chat
	
  end
	
	def send_data
		user_id = params[:user_id]
		message = params[:chat_input]
		user_chat = User.find(user_id)
		chanel = current_user.get_chanel(user_chat.id)
		if chanel
			render :juggernaut do |page|
				page.insert_html :bottom, chanel.chanel_name, "<li>#{h message}</li>"
			end
		end
		
    render :nothing => true
	end
	
	def chanel_chat_content
		user_id = params[:user_id]
		@user_chat = User.find(user_id)
		@chanel = current_user.get_chanel(@user_chat.id)
		if @chanel
			@messages = @chanel.flirting_messages
		end
	end

end
