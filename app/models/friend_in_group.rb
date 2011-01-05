class FriendInGroup < ActiveRecord::Base
  # Relations
  belongs_to :friend_group
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'user_id_friend'
end
