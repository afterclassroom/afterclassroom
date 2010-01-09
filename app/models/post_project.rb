# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostProject < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  # Relations
  belongs_to :post


  def self.paginated_post_conditions_with_due_date(params, school, type)
    cond = Caboose::EZ::Condition.new :post_projects do
      due_date > Time.now
    end
    posts = []
    post_as = PostProject.find(:all, :conditions => cond.to_sql(), :order => "due_date DESC")
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
end
