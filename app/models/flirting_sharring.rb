class FlirtingSharring < ActiveRecord::Base
	# Relations
	belongs_to :flirting_chanel
	belongs_to :user
end
