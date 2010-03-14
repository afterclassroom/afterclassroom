# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Department < ActiveRecord::Base
  # Validations
  validates_presence_of :department_category_id
  validates_presence_of :name

  # Relations
  belongs_to :department_category
  has_many :post_assignments, :dependent => :destroy
  has_many :post_projects, :dependent => :destroy
  has_many :post_tests, :dependent => :destroy
  has_many :post_exams, :dependent => :destroy
  has_many :post_books, :dependent => :destroy
  has_many :post_jobs, :dependent => :destroy
  has_many :post_tutors, :dependent => :destroy
  has_and_belongs_to_many :schools

  # Named Scope
  named_scope :of_school, lambda {|c| return {} if c.nil?; {:joins => :schools, :conditions => ["departments_schools.school_id = ?", c], :order => "department_category_id ASC"}}

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
