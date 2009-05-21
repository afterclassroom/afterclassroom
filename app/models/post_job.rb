# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostJob < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :responsibilities
  validates_presence_of :required_skills
  validates_presence_of :desirable_skills
  validates_presence_of :edu_experience_require

  # Relations
  belongs_to :post
  has_and_belongs_to_many :job_types

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      search_name = params[:search][:name]
    end

    cond = Caboose::EZ::Condition.new :posts do
      any{title =~ "%#{search_name}%"; description =~ "%#{search_name}%"} if search_name
      school_id == school.id if school
    end
    cond << "id IN (Select post_id From post_jobs)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      department_id == post.department_id
    end
    cond << "id IN (Select post_id From post_jobs)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end
end
