# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostMyx < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  named_scope :prof_filter, lambda {|c| return {} if c.nil?; {:conditions => ["prof_status = ?", c], :order => "prof_status DESC", :limit => 5}}

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_shool, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :due_date, :conditions => ["due_date > ?", Time.now], :order => "due_date DESC"

  # Tags
  acts_as_taggable

  def score
    if self.good == 0 && self.bored == 0 && self.bad == 0
      return 0
    else
      return (self.good.to_f / (self.good.to_f + self.bored.to_f + self.bad.to_f)) * 100
    end
  end
end
