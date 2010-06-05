class FriendGroup < ActiveRecord::Base
  # Relations
  has_many :friend_in_groups
end
