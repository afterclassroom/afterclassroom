# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostMyx < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  # Tags
  acts_as_taggable

  # Rating for Bad, Bored, Good
  # Bad: 0
  # Bored: 1
  # Good: 2
  acts_as_rated :rating_range => 0..2, :with_stats_table => true
  
  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :prof_filter, lambda {|c| return {} if c.nil?; {:conditions => ["prof_status = ?", c], :order => "prof_status DESC", :limit => 5}}
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

  def self.goods
    posts = []
    post_as = self.with_school(school)
    post_as.select {|p| posts << p.post if p.score >= 50}
    posts
  end

  def self.bads
    posts = []
    post_as = self.with_school(school)
    post_as.select {|p| posts << p.post if p.score < 50}
    posts
  end

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 2])
  end

  def total_bored
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
  
  def score
    total = self.total_good + self.total_bored + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end
end
