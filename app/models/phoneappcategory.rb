class Phoneappcategory < ActiveRecord::Base
  has_many :phoneapplications, :dependent => :destroy
end
