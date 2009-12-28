# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignment < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      query = params[:search][:query]
    end
    
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    
    type = PostCategory.find_by_name("Assignments").id
    
    cond = Caboose::EZ::Condition.new :posts do
      post_category_id == type if type
      school_id == school.id if school
      school_year == year if year
      department_id == department if department
      created_at > Time.now - over.day
    end
    
    if query
      Post.find_with_ferret(query, :conditions => cond.to_sql(), :order => "created_at DESC")
    else
      Post.find(:all, :conditions => cond.to_sql(), :order => "created_at DESC")
    end
  end

  def self.paginated_post_more_like_this(post)
    type = PostCategory.find_by_name("Assignments").id
    cond = Caboose::EZ::Condition.new :posts do
      post_category_id == type if type
      department_id == post.department_id
    end
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end
end
