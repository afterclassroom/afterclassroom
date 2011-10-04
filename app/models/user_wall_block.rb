class UserWallBlock < ActiveRecord::Base
	# Relations
	belongs_to :user
	belongs_to :user_wall
end
