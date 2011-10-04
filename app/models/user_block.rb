class UserBlock < ActiveRecord::Base
	# Relations
	belongs_to :user
	belongs_to :user_block, :class_name => "User", :foreign_key => "user_id_block"
end
