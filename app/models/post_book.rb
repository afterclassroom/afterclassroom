# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBook < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :price
  validates_presence_of :shipping_method
  
  # Relations
  belongs_to :post
  belongs_to :shipping_method

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_shool, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}

  # Tags
  acts_as_taggable
end
