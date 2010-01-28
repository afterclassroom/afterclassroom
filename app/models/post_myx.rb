# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostMyx < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  named_scope :prof_filter, lambda {|c| return {} if c.nil?; {:conditions => ["prof_status = ?", c], :order => "prof_status DESC", :limit => 5}}

  def self.paginated_post_conditions_with_more_worse(params)
    cond = Caboose::EZ::Condition.new :post_myxes do
      prof_status == 'Worse'
    end
    postMyxes = []
    post_as = PostMyx.find(:all, :conditions => cond.to_sql())
    post_as.select {|p| postMyxes << p.post}
    postMyxes.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_more_good(params)
    cond = Caboose::EZ::Condition.new :post_myxes do
      prof_status == 'Good'
    end
    postMyxes = []
    post_as = PostMyx.find(:all, :conditions => cond.to_sql())
    post_as.select {|p| postMyxes << p.post}
    postMyxes.paginate :page => params[:page], :per_page => 10
  end

end
