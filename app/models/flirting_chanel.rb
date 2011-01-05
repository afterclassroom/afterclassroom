class FlirtingChanel < ActiveRecord::Base
  # Validation
  validates_uniqueness_of :chanel_name, :case_sensitive => false
	# Relations
  has_many :flirting_user_inchats, :dependent => :destroy
	has_many :flirting_messages, :dependent => :destroy
	has_many :flirting_sharrings, :dependent => :destroy
end
