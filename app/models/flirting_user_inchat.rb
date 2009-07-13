class FlirtingUserInchat < ActiveRecord::Base
  # Relations
	belongs_to :flirting_chanel
	belongs_to :
belongs_to :user_target, :class_name => 'User', :foreign_key => 'user_id_invite'   
end
