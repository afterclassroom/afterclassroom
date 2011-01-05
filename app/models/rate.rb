# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Rate < ActiveRecord::Base
  belongs_to :post
  belongs_to :rateable, :polymorphic => true
  
  attr_accessible :rate
end
