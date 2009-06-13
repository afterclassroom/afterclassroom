class FlirtingChanel < ActiveRecord::Base
	# Relations
	belongs_to :user
	belongs_to :user_target, :class_name => 'User', :foreign_key => 'user_id_target' 
	has_many :flirting_messages, :dependent => :destroy
	has_many :flirting_sharrings, :dependent => :destroy
end
