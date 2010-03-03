# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostParty < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :location
  validates_presence_of :street
  validates_presence_of :city

  # Relations
  belongs_to :post
  has_many :post_party_rsvps
  has_and_belongs_to_many :party_types

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_shool, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["id > ?", att]} }

  # Tags
  acts_as_taggable

  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end
end
