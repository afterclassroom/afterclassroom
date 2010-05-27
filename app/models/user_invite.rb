# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UserInvite < ActiveRecord::Base
  # Validations
  validates_presence_of :user, :user_target

  # Relations
  belongs_to :user
  belongs_to :user_target, :class_name => 'User', :foreign_key => 'user_id_target'
  has_and_belongs_to_many :friend_groups
  
end
