# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ProfileHelper
  def friend_status(user, user_member)
    str = ""
    if user == user_member
      str = "Me"
    else
      if user.user_friends.include?(user_member)
        str = "My friend" 
      else
        if user.user_invites_out.find_by_user_id_target(user_member.id)
          str = "You sended an invite message."
        else
          if user.user_invites_in.find_by_user_id(user_member.id)
            str = "You received an invite message."
          else
            str = "<span id=\"invite_user_id_#{user_member.id}\" rel_invite=\"#{user_member.id}\" >Invite friend</span>"
          end
        end
      end
    end
  end
	
	def chat_available(current_user, user_member)
		str = ""
		if user_member.check_user_online
			if user_member.check_user_in_chatting_session(current_user.id)
				str = "In chit chatting session"
			else 
				str = "Available to chit chat"
			end
		else
			str = "Unavailable to chit chat"
		end
	end
	
	def go_to_chat(current_user, user_member)
		str = ""
		if current_user == user_member
			str = link_to "Go to chat", {:controller => "student_louge", :action => "index"}
		else
			if user_member.check_user_online == true
				if user_member.check_user_in_chatting_session(current_user.id)
					str = link_to "Go to chat", {:controller => "student_louge", :action => "index", :user => user_member.login}
				else 
					str = link_to "Add to chat", {:controller => "student_louge", :action => "index", :user => user_member.login}
				end
			else
				str = "Unavailable to chit chat"
			end
		end
	end
end
