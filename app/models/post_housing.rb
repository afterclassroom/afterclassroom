# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousing < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :rent

  # Relations
  belongs_to :post
  has_and_belongs_to_many :housing_categories

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_shool, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :due_date, :conditions => ["due_date > ?", Time.now], :order => "due_date DESC"
  
end
