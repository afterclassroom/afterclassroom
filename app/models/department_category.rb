class DepartmentCategory < ActiveRecord::Base
  #Relations
  has_many :departments
end
