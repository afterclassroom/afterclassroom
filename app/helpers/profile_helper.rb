# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ProfileHelper
  def friend_status(user, user_friend)
    str = ""
    if user == user_friend
      str = "Me"
    else
      if user.user_friends.include?(user_friend)
        str = "My friend" 
      else
        if user.user_invites_out.find_by_user_id_target(user_friend.id)
          str = "You sended an invite message."
        else
          if user.user_invites_in.find_by_user_id(user_friend.id)
            str = "You received an invite message."
          else
            str = "<span id=\"invite_user_id_#{user_friend.id}\" rel_invite=\"#{user_friend.id}\" >Invite friend</span>"
          end
        end
      end
    end
  end
end
