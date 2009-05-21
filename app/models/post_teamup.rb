# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamup < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :teamup_category_id

  # Relations
  belongs_to :post
  belongs_to :teamup_category
  belongs_to :functional_experience

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      search_name = params[:search][:name]
    end

    cond = Caboose::EZ::Condition.new :posts do
      any{title =~ "%#{search_name}%"; description =~ "%#{search_name}%"} if search_name
      school_id == school.id if school
    end
    cond << "id IN (Select post_id From post_teamups)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      department_id == post.department_id
    end
    cond << "id IN (Select post_id From post_teamups)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end
end
