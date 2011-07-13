# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Message < ActiveRecord::Base

  is_private_message
  
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  attr_accessor :to

  def self.no_of_trash(current_user)
    Message.count(:all, :conditions => ["(sender_id = ? AND sender_deleted = ?) OR (recipient_id = ? AND recipient_deleted = ?)", current_user, true, current_user, true])

  end
  
end
