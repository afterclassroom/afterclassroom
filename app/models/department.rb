# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Department < ActiveRecord::Base
  # Validations
  validates_presence_of :department_category_id
  validates_presence_of :name

  # Relations
  belongs_to :department_category
  has_many :posts, :dependent => :destroy
  has_and_belongs_to_many :schools

  def self.paginated_departments_conditions_with_search(params)
    search = {}
    search['name'] = params[:department][:name] || nil if params[:department]
    search['department_category_id'] = params[:department][:department_category_id] || nil if params[:department]
    cond = Caboose::EZ::Condition.new :departments do
      if search['name']
        name =~ "%#{search['name']}%"
      end

      if search['department_category_id']
        department_category_id == search['department_category_id']
      end
    end
    return cond
  end
end
