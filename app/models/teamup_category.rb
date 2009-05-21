# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class TeamupCategory < ActiveRecord::Base
  # Relations
  has_many :post_teamups
end
