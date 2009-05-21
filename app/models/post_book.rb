# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBook < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :price
  validates_presence_of :shipping_method
  
  # Relations
  belongs_to :post
  belongs_to :shipping_method

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      search_name = params[:search][:name]
    end

    cond = Caboose::EZ::Condition.new :posts do
      any{title =~ "%#{search_name}%"; description =~ "%#{search_name}%"} if search_name
      school_id == school.id if school
    end
    cond << "id IN (Select post_id From post_books)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      department_id == post.department_id
    end
    cond << "id IN (Select post_id From post_books)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end
end
