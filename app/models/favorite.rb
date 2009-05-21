# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Favorite < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :post
end
