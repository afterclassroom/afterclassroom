class FriendGroup < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :user_invites
end
