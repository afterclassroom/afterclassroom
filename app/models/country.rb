# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Country < ActiveRecord::Base
  # Relations
  has_many :states
  has_many :cities
  
  #Named scopes
  #SQL: select * from countries where (select count(*) from cities where cities.country_id = countries.id) > 0
  cond = "(select count(*) from cities where cities.country_id = countries.id) > 0"
  named_scope :has_cities, :conditions => cond
end
