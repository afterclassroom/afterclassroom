# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UserInformation < ActiveRecord::Base
  belongs_to :user
	before_save :remove_protocol_of_website

	protected
	def remove_protocol_of_website
		self.website = self.website.gsub(/(http:\/\/|https:\/\/)/, "") if self.website
	end
end
