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

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      search_name = params[:search][:name]
    end

    cond = Caboose::EZ::Condition.new :posts do
      any{title =~ "%#{search_name}%"; description =~ "%#{search_name}%"} if search_name
      school_id == school.id if school
    end
    cond << "id IN (Select post_id From post_parties)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      department_id == post.department_id
    end
    cond << "id IN (Select post_id From post_parties)"
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end

  def address
    str = self.street + ", " + self.city + ", " + self.location
  end
end
