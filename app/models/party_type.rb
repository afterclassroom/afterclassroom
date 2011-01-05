# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PartyType < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :post_parties
end
